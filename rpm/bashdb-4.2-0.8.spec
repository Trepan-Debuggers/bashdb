%bcond_with tests
%define rversion 4.2-0.8

Name:           bashdb
Summary:        BASH debugger, the BASH symbolic debugger
Version:        4.2_0.8
Release:        2%{?dist}
License:        GPLv2+
Group:          Development/Debuggers
Url:            http://bashdb.sourceforge.net/
Source0:        http://downloads.sourceforge.net/%{name}/%{name}-%{rversion}.tar.bz2
Buildroot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)
BuildRequires:  bash4 >= 4.1
BuildRequires:  python-pygments
Requires(post): /sbin/install-info
Requires(preun): /sbin/install-info
Requires:       bash4 >= 4.1
BuildArch:      noarch
Obsoletes:      emacs-bashdb, emacs-bashdb-el

%description
The Bash Debugger Project is a source-code debugger for bash,
which follows the gdb command syntax.
The purpose of the BASH debugger is to check
what is going on “inside” a bash script, while it executes:
    * Start a script, specifying conditions that might affect its behavior.
    * Stop a script at certain conditions (break points).
    * Examine the state of a script.
    * Experiment, by changing variable values on the fly.
The 4.0 series is a complete rewrite of the previous series.
Bashdb can be used with ddd: ddd --debugger %{_bindir}/%{name} <script-name>.

%prep
%setup -q -n %{name}-%{rversion}

%build
/usr/bin/bash4 ./configure --with-bash=/usr/bin/bash4 --prefix=/usr/local --datadir=/usr/local/share --mandir=/usr/local/share/man --infodir=/usr/local/share/info
sed -i 's:@BASHDB_MAIN@:/usr/local/share/bashdb/bashdb-main.inc:' bashdb-main.inc
make

%install
rm -rf %{buildroot}
make install INSTALL="install -p" DESTDIR=%{buildroot}
mv -v %{buildroot}/usr/local/bin/bashdb %{buildroot}/usr/local/bin/bashdb4
rm -vf "%{buildroot}%{_infodir}/dir"
touch "%{buildroot}/usr/local/share/info/dir"


%if %{with tests}
%check
# make check
%endif

%post
mkdir -p /usr/local/share/info || :
/sbin/install-info /usr/local/share/info/bashdb.info /usr/local/share/info/dir || :

%postun
if [ "$1" = 0 ]; then
   /sbin/install-info --delete %{_infodir}/%{name}.info %{_infodir}/dir || :
fi

%clean
rm -rf %{buildroot}

%files
%defattr(-,root,root,-)
%doc doc/*.html AUTHORS ChangeLog COPYING INSTALL NEWS README THANKS TODO
/usr/local/bin/bashdb4
/usr/local/share/bashdb
/usr/local/share/info/bashdb.info
/usr/local/share/info/dir
/usr/local/share/man/man1/bashdb.1


%changelog
* Sat Nov 9 2013 Rocky Bernstein <rlbernst@yu.edu> 4.2_0.9-1
- Make it work on RHEL5 for bash4

* Tue Sep 27 2011 Rocky Bernstein <rlbernst@yu.edu> 4.2_0.9-1
- Updated to 4.2-0.9

* Tue Mar 29 2011 Paulo Roma <roma@lcg.ufrj.br> 4.2_0.8-1
- Updated to 4.2-0.7

* Sun Mar 06 2011 Paulo Roma <roma@lcg.ufrj.br> 4.2_0.6-1
- Updated to 4.2-0.6
- Emacs lisp code has been removed upstream.

* Mon Feb 07 2011 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 4.1_0.4-2
- Rebuilt for https://fedoraproject.org/wiki/Fedora_15_Mass_Rebuild

* Thu Jul 22 2010 Paulo Roma <roma@lcg.ufrj.br> 4.1_0.4-1
- Updated to 4.1-0.4

* Sun Mar 14 2010 Jonathan G. Underwood <jonathan.underwood@gmail.com> - 4.0_0.4-3
- Update package to comply with emacs add-on packaging guidelines
- Split out separate Elisp source file package

* Sun Dec 27 2009 Paulo Roma <roma@lcg.ufrj.br> 4.0_0.4-2
- Updated to 4.0-0.4

* Fri Apr 10 2009 Paulo Roma <roma@lcg.ufrj.br> 4.0_0.3-2
- Updated to 4.0-0.3 for supporting bash 4.0
- Added building option "with tests".

* Wed Feb 25 2009 Paulo Roma <roma@lcg.ufrj.br> 4.0_0.2-1
- Completely rewritten for Fedora.

* Tue Nov 18 2008 Manfred Tremmel <Manfred.Tremmel@iiv.de>
- update to 4.0-0.2
