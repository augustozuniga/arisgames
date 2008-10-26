-- phpMyAdmin SQL Dump
-- version 2.11.4
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Oct 25, 2008 at 11:15 PM
-- Server version: 5.0.51
-- PHP Version: 5.2.6

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Database: `aris`
--

-- --------------------------------------------------------

--
-- Table structure for table `editors`
--

CREATE TABLE IF NOT EXISTS `editors` (
  `editor_id` int(11) NOT NULL auto_increment,
  `name` varchar(25) default NULL,
  `password` varchar(32) default NULL,
  PRIMARY KEY  (`editor_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `editors`
--

INSERT INTO `editors` (`editor_id`, `name`, `password`) VALUES
(1, 'editor', '1234');

-- --------------------------------------------------------

--
-- Table structure for table `games`
--

CREATE TABLE IF NOT EXISTS `games` (
  `game_id` int(11) NOT NULL auto_increment,
  `prefix` varchar(10) default NULL,
  `name` varchar(50) default NULL,
  PRIMARY KEY  (`game_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=43 ;

--
-- Dumping data for table `games`
--


-- --------------------------------------------------------

--
-- Table structure for table `game_editors`
--

CREATE TABLE IF NOT EXISTS `game_editors` (
  `game_id` int(11) default NULL,
  `editor_id` int(11) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `game_editors`
--
