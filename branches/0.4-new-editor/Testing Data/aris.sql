-- phpMyAdmin SQL Dump
-- version 2.11.4
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jul 26, 2009 at 05:25 PM
-- Server version: 5.0.41
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
  `super_admin` enum('0','1') NOT NULL default '0',
  `comments` tinytext,
  PRIMARY KEY  (`editor_id`),
  UNIQUE KEY `unique` (`name`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=10 ;

-- --------------------------------------------------------

--
-- Table structure for table `games`
--

CREATE TABLE IF NOT EXISTS `games` (
  `game_id` int(11) NOT NULL auto_increment,
  `prefix` varchar(50) default NULL,
  `name` varchar(100) default NULL,
  PRIMARY KEY  (`game_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=107 ;

-- --------------------------------------------------------

--
-- Table structure for table `game_editors`
--

CREATE TABLE IF NOT EXISTS `game_editors` (
  `game_id` int(11) default NULL,
  `editor_id` int(11) default NULL,
  UNIQUE KEY `unique` (`game_id`,`editor_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `game_players`
--

CREATE TABLE IF NOT EXISTS `game_players` (
  `id` int(11) unsigned NOT NULL auto_increment,
  `game_id` int(10) unsigned NOT NULL,
  `player_id` int(10) unsigned NOT NULL,
  `registered` timestamp NOT NULL default CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `unique` (`game_id`,`player_id`),
  KEY `game_id` (`game_id`),
  KEY `player_id` (`player_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=119 ;

-- --------------------------------------------------------

--
-- Table structure for table `players`
--

CREATE TABLE IF NOT EXISTS `players` (
  `player_id` int(11) unsigned NOT NULL auto_increment,
  `first_name` varchar(25) default NULL,
  `last_name` varchar(25) default NULL,
  `email` varchar(50) default NULL,
  `photo` varchar(25) default NULL,
  `password` varchar(32) default NULL,
  `user_name` varchar(30) default NULL,
  `last_location_id` int(11) default NULL,
  `latitude` double default NULL,
  `longitude` double default NULL,
  `authorization` smallint(6) NOT NULL default '0' COMMENT 'This is used to give the player editor rights',
  `site` varchar(64) NOT NULL default 'default',
  PRIMARY KEY  (`player_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=78 ;

-- --------------------------------------------------------

--
-- Table structure for table `test1_applications`
--

CREATE TABLE IF NOT EXISTS `test1_applications` (
  `application_id` int(10) unsigned NOT NULL auto_increment,
  `name` varchar(25) default NULL,
  `directory` varchar(25) default NULL,
  PRIMARY KEY  (`application_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=8 ;

-- --------------------------------------------------------

--
-- Table structure for table `test1_events`
--

CREATE TABLE IF NOT EXISTS `test1_events` (
  `event_id` int(10) unsigned NOT NULL auto_increment,
  `description` tinytext COMMENT 'This description is not used anywhere in the game. It is simply for reference.',
  PRIMARY KEY  (`event_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

-- --------------------------------------------------------

--
-- Table structure for table `test1_items`
--

CREATE TABLE IF NOT EXISTS `test1_items` (
  `item_id` int(11) unsigned NOT NULL auto_increment,
  `name` varchar(100) default NULL,
  `description` text,
  `media` varchar(50) NOT NULL default 'item_default.jpg',
  `type` enum('AV','Image') NOT NULL default 'Image',
  `event_id_when_viewed` int(10) unsigned default NULL,
  PRIMARY KEY  (`item_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

-- --------------------------------------------------------

--
-- Table structure for table `test1_locations`
--

CREATE TABLE IF NOT EXISTS `test1_locations` (
  `location_id` int(11) NOT NULL auto_increment,
  `icon` varchar(30) default NULL,
  `name` varchar(50) default NULL,
  `description` tinytext,
  `latitude` double default '43.0746561',
  `longitude` double default '-89.384422',
  `error` double default '0.0005',
  `type` enum('Node','Event','Item','Npc') default NULL,
  `type_id` int(11) default NULL,
  `item_qty` int(11) default NULL,
  `hidden` enum('0','1') default '0',
  `force_view` enum('0','1') NOT NULL default '0' COMMENT 'Forces this Location to Display when nearby',
  PRIMARY KEY  (`location_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

-- --------------------------------------------------------

--
-- Table structure for table `test1_nodes`
--

CREATE TABLE IF NOT EXISTS `test1_nodes` (
  `node_id` int(11) unsigned NOT NULL auto_increment,
  `title` varchar(100) default NULL,
  `text` text,
  `opt1_text` varchar(100) default NULL,
  `opt1_node_id` int(11) unsigned default NULL,
  `opt2_text` varchar(100) default NULL,
  `opt2_node_id` int(11) unsigned default NULL,
  `opt3_text` varchar(100) default NULL,
  `opt3_node_id` int(11) unsigned default NULL,
  `add_item_id` int(11) unsigned default NULL,
  `remove_item_id` int(11) unsigned default NULL,
  `require_answer_incorrect_node_id` int(11) unsigned default NULL,
  `add_event_id` int(11) unsigned default NULL,
  `remove_event_id` int(11) unsigned default NULL,
  `require_answer_string` varchar(50) default NULL,
  `require_answer_correct_node_id` int(10) unsigned default NULL,
  `media` varchar(25) default 'mc_chat_icon.png',
  PRIMARY KEY  (`node_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=19 ;

-- --------------------------------------------------------

--
-- Table structure for table `test1_npcs`
--

CREATE TABLE IF NOT EXISTS `test1_npcs` (
  `npc_id` int(10) unsigned NOT NULL auto_increment,
  `name` varchar(30) NOT NULL default '',
  `description` tinytext,
  `text` tinytext,
  `media` varchar(30) default NULL,
  `require_event_id` mediumint(9) default NULL,
  PRIMARY KEY  (`npc_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

-- --------------------------------------------------------

--
-- Table structure for table `test1_npc_conversations`
--

CREATE TABLE IF NOT EXISTS `test1_npc_conversations` (
  `conversation_id` int(11) NOT NULL auto_increment,
  `npc_id` int(10) unsigned NOT NULL default '0',
  `node_id` int(10) unsigned NOT NULL default '0',
  `text` tinytext NOT NULL,
  PRIMARY KEY  (`conversation_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

-- --------------------------------------------------------

--
-- Table structure for table `test1_player_applications`
--

CREATE TABLE IF NOT EXISTS `test1_player_applications` (
  `id` int(11) NOT NULL auto_increment,
  `player_id` int(10) unsigned NOT NULL default '0',
  `application_id` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;

-- --------------------------------------------------------

--
-- Table structure for table `test1_player_events`
--

CREATE TABLE IF NOT EXISTS `test1_player_events` (
  `id` int(11) NOT NULL auto_increment,
  `player_id` int(10) unsigned NOT NULL default '0',
  `event_id` int(10) unsigned NOT NULL default '0',
  `timestamp` timestamp NOT NULL default CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `unique` (`player_id`,`event_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

-- --------------------------------------------------------

--
-- Table structure for table `test1_player_items`
--

CREATE TABLE IF NOT EXISTS `test1_player_items` (
  `id` int(11) NOT NULL auto_increment,
  `player_id` int(11) unsigned NOT NULL default '0',
  `item_id` int(11) unsigned NOT NULL default '0',
  `timestamp` timestamp NOT NULL default CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  UNIQUE KEY `unique` (`player_id`,`item_id`),
  KEY `player_id` (`player_id`),
  KEY `item_id` (`item_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=3 ;

-- --------------------------------------------------------

--
-- Table structure for table `test1_qrcodes`
--

CREATE TABLE IF NOT EXISTS `test1_qrcodes` (
  `qrcode_id` int(11) NOT NULL auto_increment,
  `type` enum('Node','Event','Item','Npc') NOT NULL,
  `type_id` int(11) NOT NULL,
  PRIMARY KEY  (`qrcode_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `test1_quests`
--

CREATE TABLE IF NOT EXISTS `test1_quests` (
  `quest_id` int(11) unsigned NOT NULL auto_increment,
  `name` tinytext,
  `description` text,
  `text_when_complete` tinytext NOT NULL COMMENT 'This is the txt that displays on the completed quests screen',
  `media` varchar(50) default 'quest_default.jpg',
  PRIMARY KEY  (`quest_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2 ;

-- --------------------------------------------------------

--
-- Table structure for table `test1_requirements`
--

CREATE TABLE IF NOT EXISTS `test1_requirements` (
  `requirement_id` int(11) NOT NULL auto_increment,
  `content_type` enum('Node','Quest','Item','Npc','Location') NOT NULL,
  `content_id` int(10) unsigned NOT NULL,
  `requirement` enum('HAS_ITEM','HAS_EVENT','DOES_NOT_HAVE_ITEM','DOES_NOT_HAVE_EVENT') NOT NULL,
  `requirement_detail` int(11) NOT NULL,
  PRIMARY KEY  (`requirement_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=8 ;
