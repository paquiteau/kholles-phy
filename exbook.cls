\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{exbook}[2014/08/16 Example LaTeX class]
\makeatletter
\newif{\ifoneexerciseperpage}
\newif{\ifchap}
\newif{\ifansweronly}
\newif{\ifunited}
\answeronlyfalse
\oneexerciseperpagefalse
\chapfalse
\unitedtrue
% Options
\DeclareOption{10pt}{\PassOptionsToClass{\CurrentOption}{book}}
\DeclareOption{11pt}{\PassOptionsToClass{\CurrentOption}{book}}
\DeclareOption{12pt}{\PassOptionsToClass{\CurrentOption}{book}}
\DeclareOption{showchapter}{\chaptrue}
\DeclareOption{openany}{\PassOptionsToClass{\CurrentOption}{book}}
\DeclareOption{draft}{\PassOptionsToPackage{\CurrentOption}{book}}
\DeclareOption{exerciseonly}{\PassOptionsToPackage{\CurrentOption}{exercise}}
\DeclareOption{answeronly}{\PassOptionsToPackage{\CurrentOption}{exercise}\answeronlytrue}
\DeclareOption{answerdelayed}{\PassOptionsToPackage{\CurrentOption}{exercise}}
\DeclareOption{exercisedelayed}{\PassOptionsToPackage{\CurrentOption}{exercise}}
\DeclareOption{oneexerciseperpage}{\oneexerciseperpagetrue}
\DeclareOption{continue}{\unitedfalse}

\ProcessOptions\relax
% Base Class
\LoadClass{book}
% Main packages

\RequirePackage{graphicx}
\graphicspath{{./fig/}}
\RequirePackage[
  a4paper % paper size
  ,includeheadfoot % include header and footer into text size
  ,hmarginratio=1:1 % ratio between inner and outer margin (default)
  ,outer=1.8cm % outer margin (right)
  ,vmarginratio=1:1 % ratio between top and bottom margin
  ,bmargin=1.3cm % bottom margin
  ]{geometry}

\RequirePackage{hyperref}
	\hypersetup{colorlinks,
				citecolor=black,
				filecolor=black,
				linkcolor=black,
				urlcolor=black}
\RequirePackage[lastexercise]{exercise}

\RequirePackage{tikz}
\usetikzlibrary{decorations.pathreplacing}

% Start
\def\subtitle#1{\gdef\@subtitle{#1}}

%Configuration Exercices
% Le header n'est pas séparer du corp de l'exercise:
% c'est plus joli:

\ifunited%
\let\@afterindenttrue\@afterindentfalse
\newcommand{\saveparinfos}{%
  \edef\myindent{\the\parindent}%
  \edef\myparskip{\the\parskip}}

\newcommand{\useparinfo}{%
  \setlength{\parindent}{\myindent}%
  \setlength{\parskip}{\myparskip}}

\let\orgbeginExerciseEnv\beginExerciseEnv
\let\orgendExerciseEnv\endExerciseEnv
\renewcommand{\beginExerciseEnv}{\saveparinfos\minipage{\linewidth}\useparinfo\orgbeginExerciseEnv}
\renewcommand{\endExerciseEnv}{\orgendExerciseEnv\endminipage%
  \ifoneexerciseperpage%
  \newpage
  \fi
}

\let\orgbeginAnswerEnv\beginAnswerEnv
\let\orgendAnswerEnv\endAnswerEnv
\renewcommand{\beginAnswerEnv}{\saveparinfos\minipage{\linewidth}\useparinfo\orgbeginAnswerEnv}
\renewcommand{\endAnswerEnv}{\orgendAnswerEnv\endminipage}
\fi


\renewcommand{\ExerciseName}{Exercice}
\renewcommand{\ExerciseHeader}{\medskip\flushleft{\textbf{\large
      \ExerciseName~\ExerciseHeaderNB : \ExerciseTitle}\par}}
\renewcommand{\AnswerHeader}{\medskip\flushleft{
    \textbf{Solution~Ex.~\ExerciseHeaderNB}\par}}

\ifansweronly
  \renewcommand{\AnswerHeader}{\ExerciseHeader}
\fi

\ifchap%
  \renewcommand{\ExerciseHeaderNB}{\thechapter.\theExercise}
  \AtBeginDocument{\renewcounter{Exercise}[chapter]}
\fi%
