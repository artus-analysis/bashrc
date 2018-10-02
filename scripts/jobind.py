#!/usr/bin/env python
'''
python /afs/desy.de/user/g/glusheno/RWTH/bashrc/scripts/moveToNFS.py --dry --debug

python /afs/desy.de/user/g/glusheno/RWTH/bashrc/scripts/moveToNFS.py --dry --move moveme --to nafnfsolena
'''
import argparse

"""Script to copy files after the skim from * to nfs."""
import os
import subprocess
import pprint
import tempfile
import hashlib
pp = pprint.PrettyPrinter(indent=4)


class JobIndexes(object):

    def expandPath(self, *argv):
        print "argv:", argv
        if len(argv) == 0:
            print "Trying to expand None"
            exit(1)
        expanded_list = []
        for i in range(0, len(argv)):
            print "argv[i]:", argv[i]
            print "os.path.expanduser(argv[i]):", os.path.expanduser(argv[i])
            print "os.path.expandvars(os.path.expanduser(argv[i])):", os.path.expandvars(os.path.expanduser(argv[i]))
            print "os.path.abspath(os.path.expandvars(os.path.expanduser(argv[i]))):", os.path.abspath(os.path.expandvars(os.path.expanduser(argv[i])))
            expanded_list.append(os.path.abspath(os.path.expandvars(os.path.expanduser(argv[i]))))
        return expanded_list

    def __init__(self, era="2016"):
        self.parseArgs()
        self.gcconf = self.args.gcconf
        self.basename = "temp_jobindexes_{0}.json".format(hashlib.md5(str(self.gcconf)).hexdigest())
        self.tempfile = os.path.join(tempfile.gettempdir(), self.basename)
        bashCommand = "touch " + self.tempfile
        subprocess.Popen(bashCommand.split(), stdout=subprocess.PIPE)

    def parseArgs(self):
        parser = argparse.ArgumentParser(description='jobind.py parser')
        parser.add_argument('-g', '--gcconf', default="/nfs/dust/cms/user/glusheno/htautau/artus/ETauFakeES/2018-10-01_23-00_etaufake_tes_nom/grid-control_config.conf", type=str,
                            help='dry run')
        parser.add_argument('--dry', action='store_true', default=False,
                            help='dry run')
        parser.add_argument('--debug', action='store_true', default=False,
                            help='debug')
        parser.add_argument('-s', '--state', default=['CANCELLED', 'FAILED', 'INIT'], nargs='+', type=str, choices=['CANCELLED', 'FAILED'],
                            help='jobs state')
        parser.add_argument('--yes-on-command', action='store_true', default=False,
                            help='Do not ask before the command execution if there are no issues')

        self.args = parser.parse_args()
        self.dpprint("Parsed arguments:", self.args.__dict__)

    def dprint(self, *text):
        if self.args.debug and text is not None:
            for t in text:
                print t,
            print
            # print " ".join(map(str, text))

    def dpprint(self, *text):
        if self.args.debug and text is not None:
            for t in text:
                pp.pprint(t)
            # pp.pprint(" \n".join(map(str, text)))

    @staticmethod
    def checkDirExists(path="", critical=False):
        if not os.path.isdir(path):
            if critical:
                print "Path ", path, "... does not exist"
                exit(1)
            else:
                return False
        return True

    def getStandartizeDirectory(self, path=""):
        if len(path) > 0 and self.checkDirExists(path) and path[-1] != "/":
            path += "/"
        return path

    def yesORno(self, question):
        reply = str(raw_input(question + ' (y/n): ')).lower().strip()
        if len(reply) == 0:
            return self.yesORno("Uhhhh... please enter explicitle")
        elif reply[0].lower() == 'y':
            return True
        elif reply[0].lower() == 'n':
            return False
        else:
            return self.yesORno("Uhhhh... please enter ")

    def run(self):
        print "Run!"
        content = []
        content_int = []
        for state in self.args.state:
            bashCommand = "report.py  " + self.gcconf + " -J state:" + state + " -R location "

            print "Executing:\n", bashCommand
            with open(self.tempfile, 'w') as redirected_output:
                p = subprocess.Popen(bashCommand.split(), stdout=redirected_output)
                p.communicate()

            with open(self.tempfile) as f:
                subcontent = f.readlines()
            subcontent = subcontent[3:-1]

            if len(subcontent) == 0:
                print "No jobs in state", state
            else:
                subcontent = [x.strip().split()[0] for x in subcontent]
                subcontent_int = [int(x.strip().split()[0]) for x in subcontent]
                print "Jobs in state", state, ":", len(subcontent)
            content_int += subcontent_int
            bashCommand = "touch " + self.tempfile
            process = subprocess.Popen(bashCommand.split(), stdout=subprocess.PIPE)

        content_int = list(set(content_int))
        content_int.sort()
        content = [str(x) for x in content_int]
        ########
        # bashCommand = "report.py  " + self.gcconf + " -J state:CANCELLED -R location "# + " &> " + self.tempfile

        # print "Executing:\n", bashCommand
        # with open(self.tempfile, 'w') as redirected_output:
        #     p = subprocess.Popen(bashCommand.split(), stdout=redirected_output)
        #     p.communicate()

        # with open(self.tempfile) as f:
        #     content = f.readlines()
        # content = content[3:-1]

        # if len(content) == 0:
        #     print "No jobs"
        #     return

        # content = [x.strip().split()[0] for x in content]
        # content_int = [int(x.strip().split()[0]) for x in content]
        s = content[0]
        prev = int(s[0])
        range_start = int(s[0])
        range_end = int(s[0])
        for i in range(1, len(content)):
            if self.args.debug:
                print i, ")", content[i], ": ",
            if content_int[i] == range_end + 1:
                self.dprint("content_int[i]  == range_end + 1 :" + " range_end++: " + str(range_end + 1))
                range_end += 1
            else:
                self.dprint("content_int[i] != range_end + 1: " + str(content_int[i]) + " != " + str(range_end + 1) + " ; ")
                if range_end != range_start:
                    self.dprint("\trange_end != range_start: " + str(range_end) + " != ", str(range_start))
                    s += "-" + str(range_end)
                s += "," + content[i]
                range_start = content_int[i]
                range_end = content_int[i]
                self.dprint("\trange_start: " + str(range_start) + " range_end: " + str(range_end))
            self.dprint("\ts: " + s)

        if range_end != range_start:
            s += "-" + str(range_end)

        if prev + 1 == int(content[-1]):
            s += "-" + content[-1]

        # test
        l = []
        ss = s.split(",")
        for i in range(0, len(ss)):
            if "-" in ss[i]:
                ssss = ss[i].split("-")
                for j in range(int(ssss[0]), int(ssss[1]) + 1):
                    l.append(j)
            else:
                l.append(int(i))

        if len(l) == len(content):
            print "test fine:", len(l), "==", len(content)
        else:
            print "test not fine:", len(l), "!=", len(content)
            exit(1)

        bashCommand = "go.py " + self.gcconf + " --reset id:" + s
        if self.yesORno(question="execute? : " + bashCommand):
            process = subprocess.Popen(bashCommand.split())  # , stdout=subprocess.PIPE
            # output, error = process.communicate()
            # if error is not None:
            #     print "\treset id error:", error
            #     exit(1)
        else:
            return

        print "end"

if __name__ == '__main__':
    JobIndexes().run()
