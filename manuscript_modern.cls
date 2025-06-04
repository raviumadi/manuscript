% manuscript_modern.cls -- Clean Modern Manuscript Format (updated with author hiding feature)

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{manuscript_modern}[2025/06/03 Clean Modern Manuscript Format v1]

\LoadClass[9pt,a4paper]{article}

% ---------------------- Packages ----------------------
\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage{datetime2}
\RequirePackage{lmodern}
\RequirePackage[a4paper,margin=1.25in]{geometry}
\RequirePackage{graphicx}
\RequirePackage{amsmath,amssymb}
\RequirePackage{xcolor}
\RequirePackage{booktabs, tabularx}
\RequirePackage{fancyhdr}
\RequirePackage{setspace}
\RequirePackage{sectsty}
\RequirePackage{orcidlink}
\RequirePackage{caption}
\RequirePackage{subcaption}
\RequirePackage{tikz}
\RequirePackage{calc}
\RequirePackage{enumitem}
\RequirePackage{ifthen}
\RequirePackage{etoolbox}
\RequirePackage{booktabs, tabularx}
\RequirePackage{pgfplots}
\pgfplotsset{compat=1.18} % or an appropriate version

% ---------------------- Default Colors ----------------------
\definecolor{manuscriptblue}{HTML}{1F4E79}
\definecolor{manuscriptmaroon}{HTML}{800000}
\definecolor{manuscriptteal}{HTML}{007B7F}
\definecolor{manuscriptbrown}{HTML}{5A3E36}
\definecolor{manuscriptgrey}{HTML}{666666}
\definecolor{manuscriptgolden}{HTML}{A68B00}
\definecolor{manuscriptmagenta}{HTML}{C71585}
\definecolor{manuscriptplum}{HTML}{7E3F8F}

% ---------------------- Color Macros ----------------------
\newcommand{\@maintextcolor}{manuscriptblue}
\newcommand{\@titlecolor}{manuscriptteal}
\newcommand{\@headercolor}{manuscriptgolden}
\newcommand{\@captioncolor}{manuscriptbrown}
\newcommand{\@keywordscolor}{manuscriptplum}  % Default
\newcommand{\greyhrule}{\noindent{\color{manuscriptgrey!50}\hrule height 0.6pt}} % grey hrule

% Define proxy colors that can be used directly
\colorlet{maintextcolor}{\@maintextcolor}
\colorlet{titlecolor}{\@titlecolor}
\colorlet{headercolor}{\@headercolor}
\colorlet{captioncolor}{\@captioncolor}
\colorlet{linkhighlight}{\@titlecolor} % specifically for links
\colorlet{keywordscolor}{\@keywordscolor}    % Proxy

% Setters that update both macro and proxy color
\newcommand{\setmaintextcolor}[1]{%
	\renewcommand{\@maintextcolor}{#1}%
	\colorlet{maintextcolor}{#1}%
}
\newcommand{\settitlecolor}[1]{%
	\renewcommand{\@titlecolor}{#1}%
	\colorlet{titlecolor}{#1}%
	\colorlet{linkhighlight}{#1}%
}
\newcommand{\setheadercolor}[1]{%
	\renewcommand{\@headercolor}{#1}%
	\colorlet{headercolor}{#1}%
}
\newcommand{\setcaptioncolor}[1]{%
	\renewcommand{\@captioncolor}{#1}%
	\colorlet{captioncolor}{#1}%
}
\newcommand{\setkeywordscolor}[1]{%
	\renewcommand{\@keywordscolor}{#1}%
	\colorlet{keywordscolor}{#1}%
}



% ---------- Optional standalone submission front page ----------
% Make front page
\newif\if@frontpage
\@frontpagefalse
\newcommand{\includefrontpage}{\@frontpagetrue}


% ---------------------- Hyperref Color Setup ----------------------
\RequirePackage{hyperref}
\hypersetup{
	colorlinks=true,
	linkcolor=linkhighlight,
	citecolor=linkhighlight,
	urlcolor=manuscriptgrey!50,
	pdfborder={0 0 0}
}

% ---------------------- Main Text Color ----------------------
\AtBeginDocument{\color{\@maintextcolor}}

% ---------------------- Caption Settings ----------------------
\captionsetup{
	labelfont={color=\@captioncolor, bf, scriptsize},
	textfont={color=\@captioncolor, scriptsize}
}

% ---------------------- Header / Footer ----------------------
\fancypagestyle{fancy}{%
	\fancyhf{}
	\renewcommand{\headrulewidth}{0.4pt}
	\renewcommand{\headrule}{\hbox to\headwidth{\color{\@headercolor}\leaders\hrule height \headrulewidth\hfill}}
	\fancyhead[L]{\scriptsize\leftmark}
	\fancyfoot[R]{\textcolor{\@headercolor}{\thepage}}
}
\pagestyle{fancy}
% Define conditional footer based on anonymity
\newcommand{\firstpagefooter}{%
	\fancyfoot[L]{\color{\@headercolor!50}%
		\rule{\widthof{\small\textit{Corresponding author:} \@corname -- Email: \@coremail}}{0.4pt}\\[0.3em]
		\small\textit{Corresponding author:} \@corname -- Email: \@coremail}%
}

% Redefine footer to empty if anonymous
\AtBeginDocument{%
	\if@anonymousauthor
	\renewcommand{\firstpagefooter}{}
	\fi
}

\fancypagestyle{firstpage}{%
	\fancyhf{}
	\renewcommand{\headrulewidth}{0.9pt}
	\renewcommand{\headrule}{\hbox to\headwidth{\color{\@headercolor}\leaders\hrule height \headrulewidth\hfill}}
	\fancyhead[L]{\textcolor{\@headercolor}{\scriptsize \MakeUppercase{\@headerlabel}}}
	\fancyhead[R]{\textcolor{\@headercolor}{\scriptsize \MakeUppercase{\@date}}}
	\firstpagefooter
}

% ---------------------- Section Styling ----------------------
\sectionfont{\color{\@titlecolor}\fontsize{11}{13}\selectfont\MakeUppercase}
\subsectionfont{\color{\@titlecolor}\fontsize{10.5}{12}\selectfont}
\subsubsectionfont{\color{\@titlecolor}\fontsize{10}{11}\selectfont}

\renewcommand{\sectionmark}[1]{\markboth{\textcolor{\@headercolor}{\MakeUppercase{#1}}}{}}

% ---------------------- Abstract, Keywords, Summary ----------------------
\newcommand{\@abstract}{}
\newcommand{\@keywords}{}
\newcommand{\@summary}{}
\newcommand{\setabstract}[1]{\def\@abstract{#1}}
\newcommand{\setkeywords}[1]{\def\@keywords{#1}}
\newcommand{\setsummary}[1]{\def\@summary{#1}}

\newenvironment{summaryblock}{%
	\vskip 0.5em
	\begin{center}
		\colorbox{\@maintextcolor!5}{%
			\parbox{\dimexpr0.99\textwidth - \fboxsep}{%
				\color{\@maintextcolor}\textsc{Summary.}~\@summary
				\vskip 0.5em
			}%
		}%
	\end{center}
	\vspace{1em}
}{}

% ---------------------- Authors / Affiliations ----------------------
\newcommand{\authorlist}{}
\newcommand{\affiliationlist}{}
\newcommand{\@corname}{}
\newcommand{\@coremail}{}
\newif\if@anonymousauthor\@anonymousauthorfalse
\newcommand{\anonymousauthor}{\@anonymousauthortrue}

\newcount\authorcount
\authorcount=0

\newcommand{\addauthor}[5][]{%
	\advance\authorcount by 1
	\g@addto@macro\authorlist{#2\if\relax\detokenize{#3}\relax\else\,\textsuperscript{\orcidlink{#3}}\fi$^{#4}$ }
	\ifx#1*% star for corresponding author
	\renewcommand{\@corname}{#2}%
	\renewcommand{\@coremail}{#5}%
	\fi
}

\newcommand{\addaffiliation}[2]{%
	\g@addto@macro\affiliationlist{$^{#1}$~#2\\}
}

\newcommand{\maketitleblock}{%
	\thispagestyle{firstpage}
	\begin{center}
		{\LARGE \bfseries \raggedright\textcolor{\@titlecolor}{\@title} \par}\vskip 1em
		\if@anonymousauthor\else
		{\normalsize \raggedright {\color{\@maintextcolor}{\authorlist\par}
				\vskip 1em
				{\small \affiliationlist}}}
		\fi
		\vskip 1em
	\end{center}
	\vspace{1em}
	\noindent{\color{\@captioncolor!50}\hrule height 0.6pt}\vskip 0.5em
	\begin{center}
		\colorbox{\@headercolor!5}{%
			\parbox{\dimexpr0.99\textwidth - \fboxsep}{%
				{\color{\@captioncolor} \noindent\textsc{Abstract.} \@abstract}
			}%
		}
	\end{center}
	\vskip 0.5em
	{\color{keywordscolor}\noindent\textsc{Keywords:}  \@keywords}
	\vskip 0.5em
	\noindent{\color{\@captioncolor!50}\hrule height 0.6pt}\vskip 1.5em
}

\AtBeginDocument{%
	\if@frontpage
	\thispagestyle{empty}
	\null
	\vfill
	\begin{center}
		{\LARGE \bfseries \@title \par}\vskip 2em
		{\normalsize \authorlist \par}\vskip 1em
		{\small \affiliationlist}
		\vskip 2em
		{\textbf{Corresponding author:}} \par
		{\@corname} \\
		Email: \texttt{\@coremail}
		\vskip 2em
		{\@date}
	\end{center}
	\vfill
	\null
	\clearpage
	\fi
}
% ---------------------- Main Text Block ----------------------
\newenvironment{maintext}{
	\par\begingroup\onehalfspacing
}{\par\endgroup}

% ---------------------- Manuscript Info ----------------------
\newcommand{\@manuscriptinfo}{}
\newcommand{\setmanuscriptinfo}[1]{\def\@manuscriptinfo{#1}}

\newenvironment{manuscriptinfo}{
	\vspace{1em}
	\noindent
	\centering
	\colorbox{gray!10}{%
		\parbox{\dimexpr0.99\textwidth - \fboxsep}{%
			\textbf{Manuscript Information}\\[0.3em]
			\footnotesize\@manuscriptinfo \\
		}%
	}
	\vspace{1em}
}{}

% ---------------------- BibLaTeX ----------------------
\RequirePackage[style=nature,backend=biber]{biblatex}
\renewcommand*{\bibfont}{\footnotesize\setlength{\leftskip}{0.25\textwidth}}

% ---------------------- Line Numbers ----------------------
\RequirePackage[]{lineno}
\newif\if@linenumbers\@linenumbersfalse
\newcommand{\linenumbersOn}{\@linenumberstrue}
\newcommand{\linenumbersOff}{\@linenumbersfalse}
\AtBeginDocument{\if@linenumbers\linenumbers\fi}

% ---------- Header Label ----------
\newcommand{\@headerlabel}{Manuscript}
\newcommand{\setheaderlabel}[1]{\renewcommand{\@headerlabel}{#1}}

% ---------- Personal Pronouns (auto-singular if only 1 author) ----------
\AtBeginDocument{%
	\ifnum\authorcount=1
	\providecommand{\we}{I}
	\providecommand{\We}{I}
	\providecommand{\our}{my}
	\providecommand{\Our}{My}
	\providecommand{\ours}{mine}
	\providecommand{\Ours}{Mine}
	\providecommand{\us}{me}
	\providecommand{\Us}{Me}
	\providecommand{\ourselves}{myself}
	\providecommand{\Ourselves}{Myself}
	\else
	\providecommand{\we}{we}
	\providecommand{\We}{We}
	\providecommand{\our}{our}
	\providecommand{\Our}{Our}
	\providecommand{\ours}{ours}
	\providecommand{\Ours}{Ours}
	\providecommand{\us}{us}
	\providecommand{\Us}{Us}
	\providecommand{\ourselves}{ourselves}
	\providecommand{\Ourselves}{Ourselves}
	\fi}


\endinput