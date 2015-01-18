#!/usr/bin/python

import subprocess
from Globals import *

def formatStatus(form):
    fmat = {u"artist":"%ta", u"album":"%at", u"title":"%tt"}
    fmat.update(COLORS)
    form = form.format(**fmat)

    ## If rhythmbox is installed, rhythmbox-client should be too.
    process = subprocess.Popen(
            [u"rhythmbox-client", u"--no-start", u"--print-playing-format={}".format(form)],
            stdout=subprocess.PIPE
            )

    process.wait()
    return process.stdout.read().decode("utf-8").rstrip()

