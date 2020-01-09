#!/usr/bin/env python
'''
WARNINGS!!!!
    MIGHT OCCURE IF THE SLC IS NOT THE SAME AS USED FOR FILES CREATION!
    Do setshapes first or any other new CMSSW release

Examples:

for year in  2017 #2017
do
    d=/net/scratch_cms3b/hlushchenko/artus/MSSM_Legacy_mva_v0/delme/MSSM_${year}
    d2=/net/scratch_cms3b/hlushchenko/artus/MSSM_Legacy_mva_v0/per_channel/MSSM_${year}
        dcacheGCcopy.py \
    --debug \
        $(find ${d} -wholename "${d}/*/merged" -type d) \
        $(find ${d2} -wholename "${d2}/*/merged" -type d) \
    --n-threads $CORES \
    --yes-on-command --delay 5 --dry --check
done


dcacheGCcopy.py \
    --debug \
        /net/scratch_cms3b/hlushchenko/artus/MSSM_Legacy_mva_v0/delme/MSSM_2017/mc_METunc_shifts/f10/analysis_2019-10-18_17-53/merged \
        /net/scratch_cms3b/hlushchenko/artus/MSSM_Legacy_mva_v0/delme/MSSM_2017/mc_btagging_shifts/f3/analysis_2019-10-18_17-53/merged \
    --n-threads 1 \
    --yes-on-command --delay 5 --dry --check


--input-json


'''
import argparse
import json
"""Script to copy files after the skim from * to nfs."""
import os
import subprocess
import pprint
pp = pprint.PrettyPrinter(indent=4)

import tempfile
import hashlib
import time
# import os
import pickle
# import tqdm
# import filecmp
# import sys, json
from multiprocessing import Pool
from XRootD.client import File, FileSystem
# source /cvmfs/sft.cern.ch/lcg/views/LCG_95/x86_64-slc6-gcc8-opt/setup.sh


def check(fname):
    print 'DcacheGCcopy::check'

    # local
    fname1 = fname.replace(
        'srm://grid-srm.physik.rwth-aachen.de:8443/srm/managerv2?SFN=/pnfs/physik.rwth-aachen.de/cms//store/user/ohlushch/artus/MSSM_Legacy_mva_v0/pipelines_merged',
        '/net/scratch_cms3b/hlushchenko/artus/MSSM_Legacy_mva_v0'
    )
    with File() as f:
        print 'fname1:', fname1,
        f.open(fname1)
        size = f.stat()[1].size
        print size
        f.close()

    with File() as f:
        try:
            # remote
            fname2 = fname.replace(
                'srm://grid-srm.physik.rwth-aachen.de:8443/srm/managerv2?SFN=/pnfs/physik.rwth-aachen.de/cms//store/user/',
                "root://grid-se004.physik.rwth-aachen.de:1094//store/user/"
            )
            print 'fname2:', fname2,
            f.open(fname2)

            try:
                size_copied = f.stat()[1].size
                print size
            except:
                print
                return False
        except:
            return False
    return (size_copied == size)


def wrapMyFunc(i, arg):
    print 'DcacheGCcopy::wrapMyFunc'
    return i, check(arg)


def update((i, ans)):
    DcacheGCcopy.bool_list[i] = ans
    # DcacheGCcopy.pbar.update()


def copy(File, source, dest):
    print 'source:', source
    print 'dest:', dest
    return
    origin = File.replace(
        'srm://grid-srm.physik.rwth-aachen.de:8443/srm/managerv2?SFN=/pnfs/physik.rwth-aachen.de/cms//store/user/ohlushch/artus/MSSM_Legacy_mva_v0/pipelines_merged',
        '/net/scratch_cms3b/hlushchenko/artus/MSSM_Legacy_mva_v0',
    )
    dest = File.replace(
        '/net/scratch_cms3b/hlushchenko/artus/MSSM_Legacy_mva_v0',
        'srm://grid-srm.physik.rwth-aachen.de:8443/srm/managerv2?SFN=/pnfs/physik.rwth-aachen.de/cms//store/user/ohlushch/artus/MSSM_Legacy_mva_v0/pipelines_merged',
    )
    if not dest.startswith('srm://grid-srm.physik.rwth-aachen.de:'):
        print "problem with: ", "xrdcp  {} {}".format(origin, dest)
        raise
        return
    # print "xrdcp {} {}".format(origin, dest)
    # os.system("xrdcp  {} {}".format(origin, dest))
    # print "gfal-copy -t 7200 {} {}".format(origin, dest)
    os.system("gfal-copy -t 7200  {} {}".format(origin, dest))


class DcacheGCcopy(object):
    """Class to copy files after the skim from * to nfs."""

    # ussed to store common location accesed per-account
    # needed to estimate the sub-directory structure that has to be preserved
    common_locations = {
        # "to_private": "to_private_placeholder",
        "nafnfs": "/nfs/dust/cms/user/",
        "nafnfs_zeus": "/nfs/dust/zeus/group/",
    }

    def expandPath(self, *argv):
        # print "argv:", argv
        # print "type(argv):", type(argv)
        if len(argv) == 0:
            # print "Trying to expand None"
            exit(1)
        expanded_list = []
        for i in range(0, len(argv)):
            # print "argv[i]:", argv[i]
            # print "os.path.expanduser(argv[i]):", os.path.expanduser(argv[i])
            # print "os.path.expandvars(os.path.expanduser(argv[i])):", os.path.expandvars(os.path.expanduser(argv[i]))
            # print "os.path.abspath(os.path.expandvars(os.path.expanduser(argv[i]))):", os.path.abspath(os.path.expandvars(os.path.expanduser(argv[i])))
            expanded_list.append(os.path.abspath(os.path.expandvars(os.path.expanduser(argv[i]))))
        # print "end expandPath"
        return expanded_list

    def __init__(self, era="2016"):
        self.parseArgs()
        self.currentDirectory = os.getcwd() + "/"

        self.output = self.args.output
        self.inputs = self.args.inputs
        self.debug = self.args.debug
        self.dry = self.args.dry
        self.check = self.args.check
        self.copy = self.args.copy
        self.yes_on_command = self.args.yes_on_command
        self.list_outputfiles = set()
        self.force = self.args.force
        self.recreate = self.args.recreate
        self.delay = self.args.delay
        self.n_threads = self.args.n_threads
        self.popen_dict = {}
        self.popen = []

        if len(self.inputs) < 2:
            print "Wrong number of inputs"
            exit(1)
        map(self.expandPath, self.inputs)
        for i in self.inputs:
            if not self.checkDirExists(path=i):
                print "Input path", i, "does not exist"
                exit(1)

        if self.output is None:
            self.output = "dcacheCOcopy{0}/".format(hashlib.md5(" ".join(self.inputs)).hexdigest())
        self.output = self.expandPath(self.output)[0]
        if self.output[0] == ".":
            self.output = self.currentDirectory + self.output[2:]

    def parseArgs(self):
        parser = argparse.ArgumentParser(description='dcacheGCcopy.py parser')
        parser.add_argument('--output', '-o', default=None, type=str,
                            help='Output directory')
        parser.add_argument('--input-json', default=None, type=str,
                            help='input files')
        parser.add_argument('inputs', metavar='I', type=str, nargs='+',
                            help='Pathes to merged folders from gc output')
        parser.add_argument('--user', default="",
                            help='User name that should coinside with the user name in the base directory From where the subdirectory structure will be constructed')
        parser.add_argument('--dry', action='store_true', default=False,
                            help='dry run')
        parser.add_argument('--check', action='store_true', default=False,
                            help='check')
        parser.add_argument('--copy', action='store_true', default=False,
                            help='copy')
        parser.add_argument('--debug', action='store_true', default=False,
                            help='debug')
        parser.add_argument('-f', '--force', action='store_true', default=False,
                            help='force hadd')
        parser.add_argument('--yes-on-command', action='store_true', default=False,
                            help='Do not ask before the command execution if there are no issues')
        parser.add_argument('--recreate', action='store_true', default=False,
                            help='Delete the output folder if exists')
        parser.add_argument('-n', '--n-threads', default=1, type=int,
                            help='Number of hadd commands to run in parallel')
        parser.add_argument('--delay', default=4, type=int,
                            help='Delay between checking on number of running in parallel tasks')

        self.args = parser.parse_args()
        self.dpprint("Parsed arguments:", self.args.__dict__)

    def dprint(self, *text):
        if self.args.debug and text is not None:
            for t in text:
                print t,
            print

    def dpprint(self, *text):
        if self.args.debug and text is not None:
            for t in text:
                pp.pprint(t)

    @staticmethod
    def checkDirExists(path="", critical=False):
        if not os.path.isdir(path):
            if critical:
                print "Path ", path, "... does not exist"
                exit(1)
            else:
                return False
        return True

    def getStandartizeDirectory(self, path="", exists=True):  # exists=True - critical to exist
        self.checkDirExists(path, critical=exists)
        if len(path) > 0 and path[-1] != "/":
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

    def execCommand(self, bash_command=None, question="\nStart execution?", force_yes=False):
        if bash_command is None:
            print "execCommand has no command"
            exit(1)
        if not self.dry:
            print "\nExecuting:", bash_command
            if force_yes or self.yes_on_command or self.yesORno(question):
                process = subprocess.Popen(bash_command.split(), stdout=subprocess.PIPE)
                output, error = process.communicate()
                if len(output) > 0:
                    self.dprint("\texecCommand::output:", output)
                if error is not None:
                    print "\texecCommand::error:", error
                    exit(1)
            else:
                print "Executing declined"
        else:
            print "# Would call command:\n\t", bash_command

    def prepareOutputDir(self):
        print "\nOutput directory:", self.output

        if self.checkDirExists(self.output):
            self.dprint("Output dir exists")
            if len(os.listdir(self.output)) != 0:
                self.execCommand(bash_command="rm -rf " + self.output,
                    question="The output directory Exists. " +
                        (len(os.listdir(self.output)) != 0) *
                        ("And is not empty (" + str(len(os.listdir(self.output))) + "). ") +
                        "Would you like to delete it?: [y/n]",
                    force_yes=self.recreate)

        if not self.checkDirExists(self.output):
            self.execCommand(bash_command="mkdir --parents " + self.output,
                question="The output directory does not yet exist. Would you like to create it?: [y/n]",
                force_yes=self.recreate)

        self.output = self.getStandartizeDirectory(self.output, exists=(False if self.dry else True))

    def dirContainsNFiles(self, directory=None, n=1, extention='.root'):
        if directory is None:
            print "dirContainsNFiles needs an input"
            exit(1)
        if len(os.listdir(directory)) == n:
            # print os.listdir(directory) ; exit(1)
            for file in os.listdir(directory):
                if file[(-1) * len(extention):] == extention:
                    self.list_input_files.append(os.path.join(directory, file))
                    # print os.path.join(directory, file) ; exit(1)
                    continue
                else:
                    print "dirContainsNFiles error: ", file[(-1) * len(extention):], "!=", extention
                    exit(1)
        else:
            print "directory", directory, "has", len(os.listdir(directory)), "!=", n, "items"
            exit(1)
        return True

    def updateListOfFiles(self):
        self.dprint("updateListOfFiles::")

        for input_path in self.inputs:
            self.dprint("\tGetting filelist from input_path: ", input_path)
            onlydirs = []

            for obj in os.listdir(input_path):
                obj_fullpath = os.path.join(input_path, obj)

                # onlydirs = [os.path.join(input_path, d) for d in os.listdir(input_path) if not os.path.isdir(os.path.join(input_path, d))]
                if os.path.isdir(obj_fullpath):
                    onlydirs.append(obj)
                else:
                    continue
                self.list_outputfiles.add(obj)

            self.dprint("\t\tonlydirs:", onlydirs)

            for subdir in onlydirs:
                self.dirContainsNFiles(directory=os.path.join(input_path, subdir), n=1, extention='.root')

    @staticmethod
    def getNPopen(processes=[], status=None):
        # return filter(None, processes).count(status)
        return len([1 for p in filter(None, processes) if p.poll() == status])

    def pollPopen(self, processes=[], popen_dict={}, debug=True):
        '''Updates popen_dict, prints the status on the screen, returns N running jobs'''
        nNone = 0
        if debug:
            self.dprint("\t\tpollPopen: len:", len(processes))
        for p in filter(None, processes):
            p_poll = p.poll()
            popen_dict[p.pid]['status'] = p_poll
            if p_poll is None:
                nNone += 1
            if debug:
                self.dprint("\t\t\tpoll p:", p.pid, p_poll)
        return nNone

    @staticmethod
    def chunks(l, n):
        """Yield successive n-sized chunks from l."""
        for i in range(0, len(l), n):
            yield l[i:i + n]

    @staticmethod
    def printPopenPoll(processes=[]):
        jobs_dict = {}
        for proces in filter(None, processes):
            if proces.poll() not in jobs_dict.keys():
                jobs_dict[proces.poll()] = [proces.pid]
                continue
            jobs_dict[proces.poll()].append(proces.pid)
            # print "\t\t\tpoll p:", proces.pid, proces.poll()
        for status in jobs_dict.keys():
            print "\tjobs in status", status, ":"
            l = jobs_dict[status]
            rows, columns = os.popen('stty size', 'r').read().split()
            if len(l) > 0:
                pidlen = len(str(l[0])) + 2
                chunk_size = (int(columns) - 4) / pidlen
                print "\n".join([str(i) for i in DcacheGCcopy.chunks(l, chunk_size)])
            else:
                print '[]'
            # pp.pprint(jobs_dict[status])

    def updatePopenDict(self, processes=[], popen_dict={}):
        for proces in filter(None, processes):
            popen_dict[proces.pid]['status'] = proces.poll()

    def getCommands(self):
        commands = []
        for output_file_name in self.list_outputfiles:
            if not self.checkDirExists(os.path.join(self.output, output_file_name)):
                self.execCommand(bash_command="mkdir " + os.path.join(self.output, output_file_name),
                    question="The output sub-directory does not yet exist. Would you like to create it?: [y/n]",
                    force_yes=True)
            output_file = self.getStandartizeDirectory(os.path.join(self.output, output_file_name), exists=(False if self.dry else True)) + output_file_name + '.root'  # self.getStandartizeDirectory

            bash_command = ""
            input_files = []

            for input_path in self.inputs:
                file_path = os.path.join(input_path, output_file_name, output_file_name + '.root')
                if os.path.isfile(file_path):
                    input_files.append(file_path)

            if len(input_files) == 0:
                print "input_files can't be 0"
                exit(1)
            elif len(input_files) == 1:
                bash_command = "cp " + input_files[0] + " " + output_file
            else:
                bash_command = " ".join(["hadd " + self.force * " -f " + output_file] + input_files)

            commands.append(bash_command)
            # self.execCommand(bash_command=bash_command)
        return commands

    def getChecked(self):
        N = len(self.list_input_files)
        print "Checking {} files...".format(N)
        # DcacheGCcopy.pbar = tqdm.tqdm(total=N)
        DcacheGCcopy.bool_list = [False] * N
        # pool = Pool(processes=self.n_threads)
        pool = Pool(processes=1)
        for i, fname in enumerate(self.list_input_files):
            print i, fname
            pool.apply_async(wrapMyFunc, args=(i, fname,), callback=update)
        pool.close()
        pool.join()
        # DcacheGCcopy.pbar.close()

        self.ok_list = [x for x, valid in zip(self.list_input_files, DcacheGCcopy.bool_list) if valid]
        self.missing_list = [x for x, valid in zip(self.list_input_files, DcacheGCcopy.bool_list) if not valid]

        print "{} files successful".format(len(self.ok_list))
        print "{} files missing".format(len(self.missing_list))
        if len(self.missing_list) > 0:
            print "Check the file missing_mp_xrd!"

        with open('okay_mp_xrd', 'wb') as fp:
            pickle.dump(self.ok_list, fp)
        with open('missing_mp_xrd', 'wb') as fp:
            pickle.dump(self.missing_list, fp)

    def getCopy(self, source, dest):
        pool = Pool(processes=self.n_threads)

        pool.map(self.copy, zip(self.missing_list, source, dest))
        # zip([1,2,3,4,], 'a', 'b')
        pool.close()
        pool.join()
        del pool
        print 'processed'

    bool_list = []
    def run(self):
        self.popen_dict = {}
        self.popen = []
        self.list_input_files = []

        # self.prepareOutputDir()

        self.updateListOfFiles()
        self.dprint("List of files in merged folder:")
        self.dpprint(self.list_input_files);

        self.list_input_files = [l.replace(
            '/net/scratch_cms3b/hlushchenko/artus/MSSM_Legacy_mva_v0',
            'srm://grid-srm.physik.rwth-aachen.de:8443/srm/managerv2?SFN=/pnfs/physik.rwth-aachen.de/cms//store/user/ohlushch/artus/MSSM_Legacy_mva_v0/pipelines_merged')
            for l in self.list_input_files]

        self.dpprint(self.list_input_files)

        with open('files.txt', 'wb') as fp:
            pickle.dump(self.list_input_files, fp)

        if not self.dry:
            if self.check:
                print 'call getChecked'
                self.getChecked()
            else:
                self.missing_list = self.list_input_files
            if self.copy:
                print 'call copy'
                # self.getCopy(source='/net/scratch_cms3b/hlushchenko/artus/MSSM_Legacy_mva_v0', dest='srm://grid-srm.physik.rwth-aachen.de:8443/srm/managerv2?SFN=/pnfs/physik.rwth-aachen.de/cms//store/user/ohlushch/artus/MSSM_Legacy_mva_v0/pipelines_merged')

        # Notify about the end
        self.execCommand(bash_command='tput bel', force_yes=True)


if __name__ == '__main__':
    DcacheGCcopy().run()
