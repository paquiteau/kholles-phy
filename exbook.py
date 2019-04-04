#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jul 26 18:06:21 2018

@author: pierre-antoine
Génère un fichier .tex contenant les exercices désirés avec le formatage voulu d'après un fichier recette .bk
"""

import getopt
import sys
from glob import glob
import re
import os
import json
import locale
from collections import OrderedDict

reTitre = re.compile(r'(?<=title=)(.*?)]')

latex_accent = {
    "é": "\\'e",
    "è": "\\`e",
    "à": "\\`a",
    "ù": "\\`u",
    "ê": "\\^e",
    "î": "\\^i",
    "ô": "\\^o",
    "É": "\\'E",
    "È": "\\`E",
    "À": "\\`A",
    "ç": "\\c{c}",
    "ë": "\\¨e",
    "ü": "\\¨u",
    "ö": "\\¨o",
}


def replace_all(text, dic):
    for i, j in dic.items():
        text = text.replace(i, j)
    return text


class Exercice:
    def __init__(self, chapitre, titre, path):
        self.t = titre
        self.path = path
        self.c = chapitre

    def __repr__(self):
        return repr((self.t, self.c, self.path))


def get_list(exercices, library, chapterlist):
    exercices_objects = []
    chapter_list = dict()
    # generating database of exercises
    with open(os.path.join(library, "chapter_map")) as f:
        chapter_map = json.load(f, object_pairs_hook=OrderedDict)
    for path in exercices:
        with open(os.path.join(library, path), "r+") as f:
            data = f.read()
            if 'begin{Exercise}' in data:
                titre = reTitre.search(data).group(1)
                chapitre = re.match(r"(.*?)/", path).group(1)
                exercices_objects.append(
                    Exercice(chapitre, titre, os.path.join(library, path)))
    # formatting before importation
    if chapterlist:
        for ex in exercices_objects:  # classifying ex
            chapter_list[ex.c] = chapter_list.get(ex.c, []) + [ex]
        result = []
        for key, value in chapter_map.items():
            if chapter_list.get(key):
                result.append('\\chapter{{{0}}}'.format(
                    replace_all(value, latex_accent)))
                result.extend(['\\input{{{0}}}'.format(ex.path)
                               for ex in chapter_list[key]])
    else:
        result = ['\\input{{{0}}}'.format(ex.path) for ex in exercices_objects]
    return '\n'.join(result)


def parseTemplate(template):
    """ renvoi les paramètres par défaut du template latex """
    embeddedJsonPattern = re.compile(r"^%%:")
    f = open(template)
    code = [line[3:-1] for line in f if embeddedJsonPattern.match(line)]
    f.close()
    data = json.loads('\n'.join(code))
    parameters = dict()
    for param in data:
        parameters[param["name"]] = param
    return parameters


def toValue(parameter, data):
    if "type" not in parameter:
        return data
    elif parameter["type"] == "stringlist":
        if "join" in parameter:
            joinText = parameter["join"]
        else:
            joinText = ''
        return joinText.join(data)
    elif parameter["type"] == "color":
        return data[1:]
    elif parameter["type"] == "font":
        return data+'pt'
    elif parameter["type"] == "enum":
        return data
    elif parameter["type"] == "file":
        return data
    elif parameter["type"] == "flag":
        if "join" in parameter:
            joinText = parameter["join"]
        else:
            joinText = ''
        return joinText.join(data)


def formatDeclaration(name, parameter):
    """ déclare le macro TeX associé au paramètre 
    \def\set@<name>{\def\get<name>{}}
    """
    value = ""
    if "default" in parameter:
        value = parameter["default"]
    return '\\def\\set@{name}#1{{\\def\\get{name}{{#1}}}}\n'.format(name=name) + formatDefinition(name, toValue(parameter, value))


def formatDefinition(name, value):
    """
   Invoque le macro TeX défini précédement
    """
    return '\\set@{name}{{{value}}}\n'.format(name=name, value=value)


def recursiveFind(root_directory, pattern):
    """
    récupère tous les fichiers dans les sous-dossiers vérifiant le pattern 
    """
    matches = []
    for dirname in os.listdir(root_directory):
        if os.path.isdir(os.path.join(root_directory, dirname)):
            for filename in os.listdir(os.path.join(root_directory, dirname)):
                if filename.endswith(pattern):
                    matches.append(os.path.join(dirname, filename))
    return matches


def makeTeXfile(eb, library, output):
    """ Créer un fichier tex d'après le dictionnaire  eb """
    name = output[:-4]

    # default values
    template = "default.tmpl"
    exercises = []
    chapters = []
    showchapter = False
    if "template" in eb:
        template = eb["template"]
        del eb["template"]
    if "exercises" in eb:
        exercises = eb["exercises"]
        print(exercises)
        del eb["exercises"]
    if "chapters" in eb:
        chapters = eb["chapters"]
        del eb["chapters"]
    if "bookoptions" in eb:
        bookoptions = eb["bookoptions"]
        if "showchapter" in bookoptions:
            showchapter = True
    parameters = parseTemplate("templates/"+template)
    with open(output, 'w') as out:
        out.write('%% automatically generated , do not edit ! \n')
        out.write('\\makeatletter\n')
        # output automatic parameters
        out.write(formatDeclaration("name", {"default": name}))
        out.write(formatDeclaration("exlist", {"type": "stringlist"}))
        # output template parameter command
        for name, parameter in parameters.items():
            out.write(formatDeclaration(name, parameter))
        # output template parameter values
        for name, value in eb.items():
            if name in parameters:
                out.write(formatDefinition(
                    name, toValue(parameters[name], value)))
        # output exercise list
        if exercises == "all":
            exercises = recursiveFind(library, '.tex')
        if len(chapters) > 0:
            for chap in chapters:
                exercises += [os.path.join(chap, f)
                              for f in os.listdir(os.path.join(library, chap))
                              if f.endswith("tex")]
        if len(exercises) > 0:
            exercises = sorted(list(set(exercises)))
            out.write(formatDefinition('exlist', get_list(
                exercises, library, showchapter)))
        out.write('\\makeatother\n')

        # output templatex
        commentPattern = re.compile(r"^\s*%")
        f = open("templates/"+template)
        content = [line for line in f if not commentPattern.match(line)]

        f.close()
        out.write(''.join(content))


def usage():
    print("Pas de doc pour le moment")


def main():
    locale.setlocale(locale.LC_ALL, '')  # set script locale to match user's
    try:
        opts, args = getopt.getopt(sys.argv[1:],
                                   "hb:o:l:d",
                                   ["help", "book=", "output="])
    except getopt.GetoptError as err:
        print(str(err))
        usage()
        sys.exit(2)
    exbook = None
    output = None
    library = './exercices/'

    for o, a in opts:
        if o in ('-h', '--help'):
            usage()
            sys.exit()
        elif o in ('-b', '--book'):
            exbook = a
        elif o in ('-o', '--output'):
            output = a
        else:
            assert False, 'unhandled option'

    if exbook and output:
        with open(exbook) as f:
            eb = json.load(f)
        makeTeXfile(eb, library, output)


if __name__ == "__main__":
    main()
#    recursiveFind("./exercices/","*.tex")
