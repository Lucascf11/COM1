close all; clear all; clc;
pkg load signal;
pkg load communications;

info = [1 0 1 1 0 0 0 0 0 1 1 0 0 0 1 0];
bits = 4;
info_DEC = bi2de(reshape(info, bits, [])', 'left-msb')';





