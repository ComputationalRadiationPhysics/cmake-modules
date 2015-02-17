# - Find mallocMC library,
#     Memory Allocator for Many Core Architectures
#     https://github.com/ComputationalRadiationPhysics/mallocMC
#
# Use this module by invoking find_package with the form:
#   find_package(mallocMC
#     [version] [EXACT]     # Minimum or EXACT version, e.g. 2.0.0
#     [REQUIRED]            # Fail with an error if mallocMC or a required
#                           #   component is not found
#     [QUIET]               # Do not warn if this module was not found
#   )
#
# To provide a hint to this module where to find the mallocMC installation,
# set the MALLOCMC_ROOT environment variable.
#
# This module requires CUDA and Boost. When calling it, make sure to call
# find_package(CUDA) and find_package(Boost) first.
#
# This module will define the following variables:
#   mallocMC_INCLUDE_DIRS    - Include directories for the mallocMC headers.
#   mallocMC_FOUND           - TRUE if FindMallocMC found a working install
#   mallocMC_VERSION         - Version in format Major.Minor.Patch
#


###############################################################################
# Copyright 2014-2015 Axel Huebl, Felix Schmitt, Rene Widera,
#                     Carlchristian Eckert
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
# SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER
# RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT,
# NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE
# USE OR PERFORMANCE OF THIS SOFTWARE.
###############################################################################


###############################################################################
# Required cmake version
###############################################################################

cmake_minimum_required(VERSION 2.8.5)


###############################################################################
# mallocMC
###############################################################################

# we start by assuming we found mallocMC and falsify it if some
# dependencies are missing (or if we did not find mallocMC at all)
set(mallocMC_FOUND TRUE)


###############################################################################
# preconditions
###############################################################################

if(NOT CUDA_FOUND)
    set(mallocMC_FOUND FALSE)
    message(STATUS "could not find CUDA, try something like find_package(CUDA REQUIRED)")
elseif(CUDA_VERSION VERSION_LESS "5.0")
    set(mallocMC_FOUND FALSE)
    message(STATUS "CUDA found, but version too low (needs 5.0 or higher)")
endif(NOT CUDA_FOUND)

if(NOT Boost_FOUND)
    set(mallocMC_FOUND FALSE)
    message(STATUS "could not find Boost, try something like find_package(Boost REQUIRED)")
elseif(Boost_VERSION LESS 104800)
    set(mallocMC_FOUND FALSE)
    message(STATUS "Boost found, but version too low (needs 1.48 or higher)")
endif(NOT Boost_FOUND)


# find mallocMC installation #################################################
#
find_path(mallocMC_ROOT_DIR
  NAMES include/mallocMC/mallocMC.hpp
  PATHS ENV MALLOCMC_ROOT
  DOC "mallocMC ROOT location"
)


if(mallocMC_ROOT_DIR)
    # mallocMC headers ##########################################################
    #
    list(APPEND mallocMC_INCLUDE_DIRS ${mallocMC_ROOT_DIR}/include)


    # find version ############################################################
    #
    file(STRINGS "${mallocMC_ROOT_DIR}/include/mallocMC/version.hpp"
         mallocMC_VERSION_MAJOR_HPP REGEX "#define MALLOCMC_VERSION_MAJOR ")
    file(STRINGS "${mallocMC_ROOT_DIR}/include/mallocMC/version.hpp"
         mallocMC_VERSION_MINOR_HPP REGEX "#define MALLOCMC_VERSION_MINOR ")
    file(STRINGS "${mallocMC_ROOT_DIR}/include/mallocMC/version.hpp"
         mallocMC_VERSION_PATCH_HPP REGEX "#define MALLOCMC_VERSION_PATCH ")
    string(REGEX MATCH "([0-9]+)" mallocMC_VERSION_MAJOR
                                ${mallocMC_VERSION_MAJOR_HPP})
    string(REGEX MATCH "([0-9]+)" mallocMC_VERSION_MINOR
                                ${mallocMC_VERSION_MINOR_HPP})
    string(REGEX MATCH "([0-9]+)" mallocMC_VERSION_PATCH
                                ${mallocMC_VERSION_PATCH_HPP})

    set(mallocMC_VERSION "${mallocMC_VERSION_MAJOR}.${mallocMC_VERSION_MINOR}.${mallocMC_VERSION_PATCH}")

else(mallocMC_ROOT_DIR)
    set(mallocMC_FOUND FALSE)
    message(STATUS "Can NOT find mallocMC - set MALLOCMC_ROOT")
endif(mallocMC_ROOT_DIR)


# unset checked variables if not found ########################################
#
if(NOT mallocMC_FOUND)
    unset(mallocMC_INCLUDE_DIRS)
endif(NOT mallocMC_FOUND)


###############################################################################
# FindPackage Options
###############################################################################

# handles the REQUIRED, QUIET and version-related arguments for find_package
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(mallocMC
    REQUIRED_VARS mallocMC_INCLUDE_DIRS
    VERSION_VAR mallocMC_VERSION
)
