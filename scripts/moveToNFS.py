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
pp = pprint.PrettyPrinter(indent=4)


class MoveToNFS(object):
    """Class to copy files after the skim from * to nfs."""

    # ussed to store common location accesed per-account
    # needed to estimate the sub-directory structure that has to be preserved
    common_locations = {
        # "to_private": "to_private_placeholder",
        "nafnfs": "/nfs/dust/cms/user/",
        "nafnfs_zeus": "/nfs/dust/zeus/group/",
    }

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
        self.currentDirectory = os.getcwd() + "/"

        self.move = None
        self.move_object = None
        self.move_subdirectories_at_dest = ""
        self.moves = self.expandPath(*self.args.move)
        if len(self.moves) == 0:
            print "__init__: Can't move nothing"
            exit(1)
        self.move_isdir = False

        self.common_locations["home"] = os.path.expanduser("~") + "/"
        self.dprint("home:", self.common_locations["home"])
        self.move_from_location = None

        if self.args.user == "":
            self.login = subprocess.check_output(["whoami"])[:-1]  # , "-p"
            self.dprint("login from whoami:", self.login)
        else:
            self.login = self.args.user
            self.dprint("login:", self.login)
        for key in self.common_locations.keys():
            self.common_locations[key] = self.getStandartizeDirectory(self.common_locations[key] + self.login)

        self.to = self.args.to
        if self.args.to_private is not None:
            # Expand the system variables
            self.args.to_private = self.expandPath(self.args.to_private)[0]
            if self.args.to_private[0] == ".":
                self.args.to_private = self.currentDirectory + self.args.to_private[2:]
            self.dprint("Expanded final base-directory under which the corresponding sub-rectory wrt the user-base will be created:", self.args.to_private)

            # Check the existance of the final destination
            if not self.checkDirExists(path=self.args.to_private, critical=False):
                if self.args.yes_on_command or self.yesORno("The final base-directory does not yet exist. Would you like to create it?"):
                    bashCommand = "mkdir --parents " + self.args.to_private
                    if not self.args.dry:
                        print "Executing:", bashCommand
                        process = subprocess.Popen(bashCommand.split(), stdout=subprocess.PIPE)
                        output, error = process.communicate()
                        self.dprint("\tmkdir::output:", output)
                        if error is not None:
                            print "\tmkdir::error:", error
                            exit(1)
                    else:
                        self.dprint("# Would call command:", bashCommand)
            # self.common_locations["to_private"] = self.getStandartizeDirectory(self.args.to_private)  # self.common_locations = {     "to_private": self.getStandartizeDirectory(self.args.to_private), }
            # self.to = "to_private"
            # Save the final destination base-directory
            self.destination_root_path = self.getStandartizeDirectory(self.getStandartizeDirectory(self.args.to_private))
            self.dpprint(self.common_locations)

        else:
            if self.to is not None:
                if self.to not in self.common_locations.keys():
                    print "Reffering to unrecognized destination location -> implement it"
                    exit(1)
                self.common_locations[self.to] = self.getStandartizeDirectory(self.common_locations[self.to] + self.login)
                self.checkDirExists(path=self.common_locations[self.to], critical=True)
                self.destination_root_path = self.getStandartizeDirectory(self.common_locations[self.to])

            elif self.to is None:
                print "No final destination was recognised."
                exit(1)

        # self.destination_root_path = self.getStandartizeDirectory(self.common_locations[self.to])
        self.checkDirExists(path=self.destination_root_path, critical=True)
        self.dprint("Destination root-path:", self.destination_root_path)

        self.dprint("Current directory:", self.currentDirectory)

    '''
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
    '''

    def parseArgs(self):
        parser = argparse.ArgumentParser(description='movetoNFS.py parser')
        parser.add_argument('--move', '-m', default=[], nargs="*",
                            help='WHAT to move')
        parser.add_argument('--to', '-t', default=None, type=str,
                            help='WHERE to move')
        parser.add_argument('--to-private', default=None, type=str,
                            help='WHERE to move - private path, Example: /nfs/dust/cms/user/SOMENAME/afs/ ')
        parser.add_argument('--user', default="",
                            help='user name that should coinside with the user name in the base directory from where the subdirectory structure will be constructed')
        parser.add_argument('--dry', action='store_true', default=False,
                            help='dry run')
        parser.add_argument('--debug', action='store_true', default=False,
                            help='debug')
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

    def locateMovedFile(self):
        '''self.move - the file that will be moved'''
        '''self.move_from_location - the initial generalised location, like home'''
        '''self.move_subdirectories_at_dest - subdir structure to be created at the destination'''
        '''self.move_isdir'''
        '''self.move_object'''

        # Constract an global path of moved object
        self.dprint("Absolute path(s) of moved object(s):", self.move)

        if not os.path.exists(self.move):
            print "Moved object ... does not exist"
            exit(1)

        self.move_object = os.path.basename(self.move)
        if os.path.isdir(self.move):
            self.move_isdir = True
            self.move = self.getStandartizeDirectory(self.move)
            self.move_object = self.move.split("/")[-2]
        self.dprint("Moved object:", self.move_object)

        # Determine what subdirectory structure has to be created
        # by comparing to the base directories defined in self.common_locations
        for key, location in self.common_locations.iteritems():
            if self.move[:len(location)] == location:
                self.dprint(self.move[:len(location)], "==", location, "\n\tkey, location:", key, location)
                self.move_from_location = key
                self.move_subdirectories_at_dest = self.move[len(location):]
                split_subdirs = self.move_subdirectories_at_dest.split("/")
                # print "os.path.basename:", os.path.basename(self.move[len(location):])
                # self.dprint("split_subdirs:", split_subdirs)
                if self.move_isdir:
                    self.move_subdirectories_at_dest = "/".join(split_subdirs[:-2])
                else:
                    self.move_subdirectories_at_dest = "/".join(split_subdirs[:-1])
                self.move_subdirectories_at_dest = self.getStandartizeDirectory(self.move_subdirectories_at_dest)
                break
            else:
                self.dprint(self.move[:len(location)], "=/=", location,
                    "\n\tkey, location:", key, location, "are not known among common")

        if self.move_from_location is None:
            print "Could not estimate initial location of the object - you might want to add it to the known ones"
            exit(1)

        self.dprint("self.move_from_location:", self.move_from_location)
        self.dprint("self.move_subdirectories_at_dest:", self.move_subdirectories_at_dest)

    def locateDestination(self, move_object=None, move_subdirectories_at_dest=""):
        if move_object is None:
            print "locateDestination: Can't move nothing"
            exit(1)
        self.destination = self.getStandartizeDirectory(self.destination_root_path + move_subdirectories_at_dest)
        target = self.destination + move_object
        self.dprint("The target output:", target)

        if not self.checkDirExists(self.destination, critical=False):
            bashCommand = "mkdir --parents " + self.destination
            if not self.args.dry:
                print "Executing:", bashCommand
                if self.args.yes_on_command or self.yesORno("Start execution?"):
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
                if self.yesORno(" ".join(["Target", target, "ALREADY EXISTS!!! Cancel the execution of the script?"])):
                    exit(1)
            else:
                self.dprint("Target output creates no conflicts")

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
        for self.move in self.moves:
            self.locateMovedFile()
            self.locateDestination(move_object=self.move_object, move_subdirectories_at_dest=self.move_subdirectories_at_dest)
            bashCommand = ""

            if len(self.move) > 0:
                bashCommand = "mv " + self.move + " " + self.destination

            if not self.args.dry:
                print "Executing:", bashCommand
                if self.args.yes_on_command or self.yesORno("Start execution?"):
                    process = subprocess.Popen(bashCommand.split(), stdout=subprocess.PIPE)
                    output, error = process.communicate()
                    if len(output) > 0:
                        self.dprint("\trun::output:", output)
                    if error is not None:
                        print "\tmkdir::error:", error
                        exit(1)
                else:
                    print "Executing declined"
            else:
                print "# Would call command:", bashCommand


if __name__ == '__main__':
    MoveToNFS().run()
