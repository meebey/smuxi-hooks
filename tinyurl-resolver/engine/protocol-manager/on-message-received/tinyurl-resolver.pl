#!/usr/bin/perl
# Copyright 2009-2011, Olof Johansson <olof@ethup.se>
# Copyright 2013, Mirco Bauer <meebey@meebey.net>
#
# Copying and distribution of this file, with or without
# modification, are permitted in any medium without royalty
# provided the copyright notice are preserved. This file is
# offered as-is, without any warranty.

# This started of as a modified version of youtube-title.pl
#
# See also:
# * http://www.stdlib.se/
# * https://github.com/olof/irssi-tinyurl-resolver

# TODO:
# * Unit testing

use strict;
use LWP::UserAgent;
use Regexp::Common qw/URI/;
#use Irssi;

my $VERSION = '0.63';
my %IRSSI = (
	authors     => "Olof 'zibri' Johansson",
	contact     => 'olof@ethup.se',
	name        => 'tinyurl-resolver',
	description => 'Make long URI of tinyurl (et al) links (i.e. resolve)',
	license     => 'GNU APL',
);

my $debug = 1;
my $color = '%y';

my @tinyfiers;
add_domain('tinyurl.com');
add_domain('bit.ly');
add_domain('cot.ag');
add_domain('ow.ly');
add_domain('goo.gl');
add_domain('goo.gl/fb');
add_domain('tiny.cc');
add_domain('t.co');
add_domain('j.mp');
add_domain('cdm.fm');
add_domain('is.gd');
add_domain('fb.me');
add_domain('git.io');
add_domain('tgr.ph');
add_domain('gaa.st');
add_domain('wth.se');
add_domain('korta.nu');

#Irssi::signal_add("message public", \&handler);
#Irssi::signal_add("message private", \&handler);
#Irssi::settings_add_int('tinyurl-resolver', 'tiny_resolve_limit', 5);
#Irssi::settings_add_bool('tinyurl-resolver', 'tiny_print_chain', 0);

sub wprint {
	my $server = shift;
	my $target = shift;
	my $msg = join '', @_;

	print("Session.Command /echo $msg\n");
}

sub color {
	my $msg = shift;
	my $color = shift // $color;
    return $msg;
	#return "$color$msg%n";
}

sub resolution {
	my $server = shift;
	my $target = shift;
	my $tiny = shift;
	my $outlim = 0; # Irssi::settings_get_bool('tiny_print_chain');
	my @chain = $outlim ? @_ : ($_[$#_]);

	s/%/%%/g for (@chain);
	my $msg = color($tiny);
	$msg .= " -> ". color($_) for (@chain);

	wprint($server, $target, $msg);
}

sub invalid {
	my $url = pop;
	wprint(@_, color("$url:") . " invalid link");
}


sub add_domain {
	my $domain = shift;
	my $suffix = shift // qr{/\w+};
	my $prefix = shift // qr{(?:https?://(?:www\.)?|www\.)};

	push @tinyfiers, qr/$prefix \Q$domain\E $suffix/x;
}

sub is_tiny {
	my($url) = @_;

	for(@tinyfiers) {
		return 1 if $url =~ /^$_$/i;
	}

	return;
}

sub resolve {
	my $url = shift;
	my $lim = shift; # Irssi::settings_get_int('tiny_resolve_limit');
	my $loc = get_location($url);
	return ($loc, '...') if $lim == 0 and is_tiny($loc);
	return ($loc, resolve($loc, $lim-1)) if is_tiny($loc);
	return $loc;
}

sub get_location {
	my ($url) = @_;

	my $ua = LWP::UserAgent->new(
		max_redirect => 0,
	);

	$ua->agent("$IRSSI{name}/$VERSION (irssi)");
	$ua->timeout(3);
	$ua->env_proxy;

	my $response = $ua->head($url);

	return $response->header('location');
}

my $server = '';
my $msg = $ENV{'SMUXI_MSG'};
my $nick = $ENV{'SMUXI_SENDER'};
my $target = $ENV{'SMUXI_CHAT_ID'};
$target = $nick unless defined $target;

my @urls = $msg =~ /($RE{URI}{HTTP}{-scheme => 'https?'})/;

for my $url (@urls) {
	next unless is_tiny($url);
	my @chain = resolve($url);

	if(@chain == 0 and $debug) {
		invalid($server, $target, $url);
		next;
	}

	resolution($server, $target, $url, @chain);
}
