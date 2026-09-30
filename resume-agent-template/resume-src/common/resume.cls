\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{common/resume}[2026/08/11 Modern ATS-safe resume class]
\LoadClass[10pt]{article}

\RequirePackage[a4paper,margin=0.47in,nohead]{geometry}
\RequirePackage{fontspec}
\RequirePackage{hyperref}
\RequirePackage{enumitem}
\RequirePackage{titlesec}
\RequirePackage{xifthen}
\RequirePackage{xcolor}

\hypersetup{hidelinks}
% 字体回退链：macOS 用 Avenir Next；无此字体时回退 Helvetica Neue，再回退
% TeX Live 自带的 TeX Gyre Heros，保证 Linux / Windows 也能编译。
\IfFontExistsTF{Avenir Next}{%
  \setmainfont{Avenir Next}[
    BoldFont = {Avenir Next Bold},
    ItalicFont = {Avenir Next Italic},
  ]%
}{%
  \IfFontExistsTF{Helvetica Neue}{%
    \setmainfont{Helvetica Neue}%
  }{%
    \setmainfont{TeX Gyre Heros}%
  }%
}
\pagestyle{empty}
\setlength{\parindent}{0pt}
\setlength{\parskip}{0pt}
% Reduce awkward hyphenation at line ends (not fully disabled — keeps 1 page)
\hyphenpenalty=10000
\exhyphenpenalty=10000
\emergencystretch=3em
\setlist[itemize]{leftmargin=1.10em,itemsep=0.09em,topsep=0.11em,parsep=0pt,partopsep=0pt,label=\textbullet}

\definecolor{Accent}{HTML}{1B4F72}   % deep professional blue
\definecolor{NameColor}{HTML}{16232F}% near-black for the name
\definecolor{MutedText}{HTML}{4A4A4A}% secondary text (contact line)

% --- Section headings: bold small-caps-ish uppercase with accent rule ---
\titleformat{\section}
  {\normalsize\bfseries\color{Accent}}
  {}{0em}{}[{\vspace{-0.06em}{\color{Accent}\titlerule[0.7pt]}}]
\titlespacing*{\section}{0pt}{0.72em}{0.21em}
\newcommand{\resumeSection}[1]{\section*{#1}}

% --- Name: large, weighted, slight letter-spacing ---
\newcommand{\resumeName}[1]{\centerline{{\addfontfeature{LetterSpace=1.2}\LARGE\bfseries\color{NameColor} #1}}\vspace{0.36em}}

% --- Contact line: small, muted ---
\newcommand{\resumeContact}[1]{\centerline{\small\color{MutedText} #1}\vspace{0.55em}}

% --- Entries: bold title left, accent date right ---
\newcommand{\datedEntry}[2]{\textbf{#1}\hspace{1em}\hfill {\color{Accent}#2}\par}
\newcommand{\roleLine}[2]{\textit{#1}\hspace{1em}\hfill #2\par}
\newcommand{\resumeLink}[2][]{\ifthenelse{\isempty{#1}}{\href{#2}{#2}}{\href{#2}{#1}}}
\newcommand{\placeholder}[1]{\textcolor{gray}{\texttt{#1}}}
