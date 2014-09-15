#----------------------------------------------------------------------
#
# SDDPACK: Software for the Semidiscrete Decomposition.
# Copyright (c) 1999 Tamara G. Kolda and Dianne P. O'Leary. 
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
# 02111-1307, USA.
#
# MODULE: Makefile
#
# DESCRIPTION: Makefile for SDDPACK.
#
# USAGE: make
#
# NOTE: Some BASIC DEFINITIONS will need to be changed for different
# systems.
#
# BUG REPORTS: Email Tamara.Kolda@na-net.ornl.gov. 
#
#----------------------------------------------------------------------

#----------------------------------------------------------------------
#
# BASIC DEFINITIONS
#
# Adjust these flags for your system. Several examples are listed.
#
# Note: The -DQSORTOPT flags specifies whether or not to use the
# optimized qsort that is provided with this distribution. We suggest
# that you try testscript with and without this flag and see which is
# faster and whether or not the answers differ. The answers should
# not differ; do not use -DQSORTOPT if they do.
#
#----------------------------------------------------------------------

### Location of RM program
RM = /bin/rm

### Intel PC (Linux) or Sparc (SunOS or Solaris) 
CC = gcc 
CFLAGS = -pedantic -ansi -Wall -O3 -DQSORTOPT
LIB = -lm

### DEC ALPHA (OSF1)
#CC = cc
#CFLAGS = -O3 -DQSORTOPT
#LIB = -lm

### IBM RS6000 (AIX)
#CC = cc
#CFLAGS = -O3 
#LIB = -lm

### SGI Octane (IRIX 64)
#CC = cc
#CFLAGS = -64 -ansi -O3 -DQSORTOPT
#LIB = -lm

#----------------------------------------------------------------------
#
# MAIN PROGRAMS (do not modify)
#
#----------------------------------------------------------------------

INC = -Iinclude
PROGS = decomp convertmtx convertsdd
OBJ = sdd.o

all : $(PROGS)
	@echo 'Make complete'

convertmtx : src/convertmtx.c include/sdd.h sdd.o 
	$(CC) $(CFLAGS) $(INC) src/convertmtx.c sdd.o $(LIB) -o $@

convertsdd : src/convertsdd.c include/sdd.h sdd.o 
	$(CC) $(CFLAGS) $(INC) src/convertsdd.c sdd.o $(LIB) -o $@

decomp : src/decomp.c $(OBJ)
	$(CC) $(CFLAGS) $(INC) src/decomp.c $(OBJ) $(LIB) -o $@

#----------------------------------------------------------------------
#
# COMMON OBJECT FILES (do not modify)
#
#----------------------------------------------------------------------

sdd.o : src/sdd.c include/sdd.h include/qsortopt.h
	$(CC) -c $(CFLAGS) $(INC) src/sdd.c

#----------------------------------------------------------------------
#
# UTILITIES (do not modify)
#
#----------------------------------------------------------------------

clean:
	-$(RM) -f $(OBJ) core 

clobber: clean
	-$(RM) -f $(PROGS)

remake: clobber all
	@echo 'Remake complete' 

#----------------------------------------------------------------------
# CREATE TAR FILE FOR DISTRIBUTION
#----------------------------------------------------------------------

tarfiles: 
	cd .. ;	tar czvf SDDPACK.tgz \
	SDDPACK/README.html \
	SDDPACK/Makefile \
	SDDPACK/gpl.txt \
	SDDPACK/include/sdd.h \
	SDDPACK/include/qsortopt.h \
	SDDPACK/src/sdd.c \
	SDDPACK/src/decomp.c \
	SDDPACK/src/convertmtx.c \
	SDDPACK/src/convertsdd.c \
	SDDPACK/matlab/mtxread.m \
	SDDPACK/matlab/mtxwrite.m \
	SDDPACK/matlab/sdd.m \
	SDDPACK/matlab/sddweight.m \
	SDDPACK/matlab/sddtensor.m \
	SDDPACK/matlab/sddfun.m \
	SDDPACK/matlab/sddweightfun.m \
	SDDPACK/testdata/test1.mtx \
	SDDPACK/testdata/test1.gif \
	SDDPACK/doc/umcp-cs-tr-4012.ps 
	cd .. ; tar czvf mtxfiles.tgz \
	SDDPACK/testdata/bfw62a.mtx \
	SDDPACK/testdata/impcol_c.mtx \
	SDDPACK/testdata/watson2.mtx \
	SDDPACK/testdata/west0132.mtx
	/bin/mv ../SDDPACK.tgz ../mtxfiles.tgz .



