#!/usr/bin/env python

"""
from https://root.cern.ch/phpBB3/viewtopic.php?f=14&t=12521

like rot.py, but
	- python instead of ipython
	- no print __doc__
	- no loading of kappa lib
	- no terminal output

Usage: ro.py rootfile.root

"""

import os, sys, time

def main():
	os.close(0)  # close stdin BEFORE importing ROOT
	import ROOT

	infiles=[ROOT.TFile.Open(name) for name in sys.argv[1:]]
	tbrowse=ROOT.TBrowser()

	try:
		while tbrowse:
			time.sleep(1)
	except KeyboardInterrupt,e:
		pass

if __name__ == "__main__":
	try:
		sys.exit(main())
	except SystemExit:
		pass
