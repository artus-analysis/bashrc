#!/usr/bin/env python
'''
python /afs/desy.de/user/g/glusheno/RWTH/bashrc/scripts/moveToNFS.py --dry --debug

python /afs/desy.de/user/g/glusheno/RWTH/bashrc/scripts/moveToNFS.py --dry --move moveme --to nafnfsolena
'''
import argparse

"""Script to copy files after the skim from * to nfs."""
import os
import subprocess
import shlex
import shutil
import pprint
pp = pprint.PrettyPrinter(indent=4)


class MoveToNFS(object):
    """Class to copy files after the skim from * to nfs."""

    common_locations = {
        "nafnfs": "/nfs/dust/cms/user/",
        "nafnfs-olena": "/nfs/dust/cms/user/glusheno/afs/",
    }

    def __init__(self, era="2016"):
        self.parseArgs()

        self.move_request = os.path.expandvars(self.args.move)
        self.move = self.move_request
        if len(self.move_request) == 0:
            print "Can't move nothing"
            exit(1)
        self.move_isdir = False

        self.common_locations["home"] = os.path.expanduser("~") + "/"
        self.dprint("home:", self.common_locations["home"])
        self.move_from_location = None

        if len(self.args.to_private) > 0:
            self.args.to_private = os.path.expanduser(self.args.to_private)
            self.checkDirExists(path=self.args.to_private, critical=True)
            self.common_locations["to_private"] = self.getStandartizeDirectory(self.args.to_private)

        self.login = subprocess.check_output(["whoami"])[:-1]  # , "-p"
        self.dprint("whoami:", self.login)
        self.common_locations["nafnfs"] = self.getStandartizeDirectory(self.common_locations["nafnfs"] + self.login)
        self.checkDirExists(path=self.common_locations["nafnfs"], critical=True)

        if self.args.to not in self.common_locations.keys():
            print "Unrecognized destination location -> implement it"
            exit(1)
        self.destination_root_path = self.getStandartizeDirectory(self.common_locations[self.args.to])
        self.checkDirExists(path=self.destination_root_path, critical=True)
        self.dprint("Destination root-path:", self.destination_root_path)

        self.currentDirectory = os.getcwd() + "/"
        self.dprint("Current directory:", self.currentDirectory)

    def parseArgs(self):
        parser = argparse.ArgumentParser(description='movetoNFS.py parser')
        parser.add_argument('--move', '-m', default="",
                            help='WHAT to move')
        parser.add_argument('--to', '-t', default="",
                            help='WHERE to move')
        parser.add_argument('--to-private', default="",
                            help='WHERE to move - private path, Example: /nfs/dust/cms/user/SOMENAME/afs/ ')
        parser.add_argument('--user', default="",
                            help='user name')
        parser.add_argument('--dry', action='store_true', default=False,
                            help='dry run')
        parser.add_argument('--debug', action='store_true', default=False,
                            help='debug')
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

    def locateMovedFile(self):
        '''self.move - the file that will be moved'''
        '''self.move_from_location - the initial generalised location, like home'''
        '''self.move_subdirectories_at_dest - subdir structure to be created at the destination location where the files will be moved'''
        '''self.move_isdir'''
        '''self.move_object'''

        # Constract an global path of moved object
        self.move = os.path.abspath(self.move_request)  # if self.move_request[0] != "/": self.currentDirectory + self.move_request
        self.dprint("Apsolute path of moved object:", self.move)

        if not os.path.exists(self.move):
            print "Moved object ... does not exist"
            exit(1)
        
        self.move_object = os.path.basename(self.move)
        if os.path.isdir(self.move):
            self.move_isdir = True
            self.move = self.getStandartizeDirectory(self.move)
            self.move_object = self.move.split("/")[-2]
        self.dprint("Moved object:", self.move_object)

        # Determine what location is moving FROM; what subdir has to be made
        print "==="
        for key, location in self.common_locations.iteritems():
            if self.move[:len(location)] == location:
                self.move_from_location = key

                self.move_subdirectories_at_dest = self.move[len(location):]
                split_subdirs = self.move_subdirectories_at_dest.split("/")
                # print "os.path.basename:", os.path.basename(self.move[len(location):])
                # self.dprint("split_subdirs:", split_subdirs)
                if self.move_isdir: self.move_subdirectories_at_dest = "/".join(split_subdirs[:-2])
                else: self.move_subdirectories_at_dest = "/".join(split_subdirs[:-1])
                self.move_subdirectories_at_dest = self.getStandartizeDirectory(self.move_subdirectories_at_dest)

                break

        if self.move_from_location is None:
            print "Could not estimate initial location of the object"
            exit(1)

        self.dprint("self.move_from_location:", self.move_from_location)
        self.dprint("self.move_subdirectories_at_dest:", self.move_subdirectories_at_dest)

    def locateDestination(self):
        self.destination = self.getStandartizeDirectory(self.destination_root_path + self.move_subdirectories_at_dest)
        target = self.destination + self.move_object
        self.dprint("The target output:", target)

        if not self.checkDirExists(self.destination, critical=False):
            bashCommand = "mkdir --parents " + self.destination
            if not self.args.dry:
                print "Executing:", bashCommand
                if self.yesORno("Start execution?"):
                    process = subprocess.Popen(bashCommand.split(), stdout=subprocess.PIPE)
                    output, error = process.communicate()
                    self.dprint("\tmkdir::output:", output)
                    if error is not None:
                        print "\tmkdir::error:", error
                        exit(1)
                else:
                    print "Executing declined"
            else:
                print "# Would call command:", bashCommand
        else:
            if os.path.exists(target):
                if self.yesORno( " ".join(["Target", target, "ALREADY EXISTS!!!!! Cancel the execution of the script?"])):
                    exut(1)
            else:
                self.dprint("Target output creates no conflicts")
              
    def yesORno(self, question):
        reply = str(raw_input(question+' (y/n): ')).lower().strip()
        if len(reply) == 0:
            return self.yesORno("Uhhhh... please enter explicitle")
        elif reply[0].lower() == 'y':
            return True
        elif reply[0].lower() == 'n':
            return False
        else:
            return self.yesORno("Uhhhh... please enter ")

    def run(self):
        print "Hello, world!"

        self.locateMovedFile()
        self.locateDestination()
        bashCommand = ""

        if len(self.move) > 0:
            bashCommand = "mv " + self.move + " " + self.destination

        if not self.args.dry:
            print "Executing:", bashCommand
            if self.yesORno("Start execution?"):
                process = subprocess.Popen(bashCommand.split(), stdout=subprocess.PIPE)
                output, error = process.communicate()
                if len(output) > 0: self.dprint("\trun::output:", output)
                if error is not None:
                    print "\tmkdir::error:", error
                    exit(1)
            else:
                print "Executing declined"
        else:
            print "# Would call command:", bashCommand

if __name__ == '__main__':
    MoveToNFS().run()
