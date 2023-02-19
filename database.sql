-- phpMyAdmin SQL Dump
-- version 4.9.7
-- https://www.phpmyadmin.net/
--
-- Host: mysql11.domainhotelli.fi:3306
-- Generation Time: Feb 19, 2023 at 02:26 AM
-- Server version: 10.5.18-MariaDB-cll-lve
-- PHP Version: 7.4.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `zavawzyv_open_query`
--

-- --------------------------------------------------------

--
-- Table structure for table `attack`
--

CREATE TABLE `attack` (
  `game_id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `attacker_id` int(11) NOT NULL,
  `target_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `card`
--

CREATE TABLE `card` (
  `id` int(11) NOT NULL,
  `cost` int(11) NOT NULL,
  `power` int(11) NOT NULL,
  `finnish_name` varchar(32) NOT NULL,
  `english_name` varchar(32) NOT NULL,
  `finnish_effects` varchar(96) NOT NULL,
  `english_effects` varchar(96) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `card`
--

INSERT INTO `card` (`id`, `cost`, `power`, `finnish_name`, `english_name`, `finnish_effects`, `english_effects`) VALUES
(0, 3, 4, 'Viinivalli', 'Wine Wabble', 'Pelin lopussa, tuplaa tämän kortin voima.', 'At the end of game, double this card\'s power.'),
(1, 1, 2, 'Isä Kallio', 'Hillmaker', 'Jos tämä kortti on kentällä, tuplaa sen voima vuoron lopussa.', 'If this card is on the field, double its power at the end of turn.'),
(2, 0, 1, 'Lapsi', 'Child', 'Kostan äitini puolesta!', 'I\'ll revenge my mom!'),
(3, 3, 4, 'Märkä Marjatta', 'Moist Monica', 'Kun tämä kortti kuolee, se synnyttää lapsen.', 'When this card dies, it gives birth to a child.'),
(4, 6, 1, 'Musta Jeesus', 'Jesus Black', 'Jos tämä kortti on kädessäsi, se saa kolme voimaa vuoron lopussa.', 'If this card is in your hand, it gains three power at the end of turn.'),
(5, 2, 4, 'Valonviejä', 'Spot Taker', 'Mustat miehet tanssii yöllä, ja kaikki tietää sen.', 'Black revelers dance at night, and everyone knows it.'),
(6, 2, 5, 'Lumiukko', 'Snowman', 'Jos tämä kortti on kädessäsi, se menettää kaksi voimaa vuoron lopussa.', 'If this card is in your hand, it loses two power at the end of turn.'),
(7, 1, 3, 'Futarityttö Linnea', 'Football Girl Linda', 'Koulun paras futiksen pelaaja.', 'Best football player in the school.'),
(8, 3, 3, 'Kuoleman Tuuli', 'Death God Tuuli', 'Kuollessa -kyvyt tapahtuvat kahdesti.', 'Dying effects happen twice.'),
(9, 0, 1, 'Nakkivene', 'Sausage Boat', 'Kun tämä kortti kuolee, muut nolla-maksuiset kortit saavat yhden voiman.', 'When this card dies, other zero-cost cards gain one power'),
(10, 3, 5, 'Vihreä Ninja', 'Emerald Shogun', 'Hän palauttaa vastustajan voiman takaisin kaksinkertaisena.', 'He returns the opponent\'s power back in double.'),
(11, 5, 9, 'Veitsi Veikko', 'Knife  Kevin', 'Hänen veitsiään ei voi väistää kukaan.', 'No one can evade the speed of his knives.'),
(12, 10, 16, 'Tulevan Luoja', 'Future Anomaly', 'Jos tämä kortti on kädessäsi, sen hinta laskee yhdellä vuoron lopussa.', 'If this card is in your hand, it cost decreases by one at the end of turn.'),
(13, 4, 5, 'Henki Mira', 'Yokai Mirai', 'Vuoron lopussa -kyvyt tapahtuvat kahdesti.', 'End of turn -effects happen twice.'),
(14, 1, 2, 'Ananas Mies', 'Pineapple Man', 'Jos tämä kortti on pakassasi, se saa vuoron lopussa yhden voiman.', 'If this card is in your deck, it gains one power at the end of turn.'),
(15, 4, 6, 'Herättävä Henna', 'Insomniac Iris', 'Kuollessa -kyvyt eivät toimi.', 'Dying effects do not work.'),
(16, 5, 2, 'Bitcoin Keisari', 'Don Bitcoin', 'Vuoron lopussa, tuplaa kädessäsi olevien korttien voima.', 'At the end of turn, double the power of each card in your hand.'),
(17, 3, 2, 'Kiinan Tiikeri', 'Paper Tiger', 'Kun pelaat tämän kortin, neljä-maksuisten korttien hinta käsissä laskee kahdella.', 'When you play this card, four-cost cards in hands have their cost reduced by two.'),
(18, 1, 1, 'Toveri Otso', 'Comrade Winnie', 'Kun tämä kortti kuolee, nosta kortti vastustajasi pakasta.', 'When this card dies, draw a card from your opponent\'s deck.'),
(19, 4, 5, 'Rohkea Niilo', 'Brave Nick', 'Kun tämä kortti kuolee, muut korttisi saavat yhden voiman.', 'When this card dies, your other cards gain one power.'),
(20, 6, 12, 'Mipopi Dinomuoto', 'Mipopi Dinoform', 'Uskotko nyt dinosauruksiin, Peitse?', 'Do you believe in dinosaurs now, Pent?'),
(21, 4, 7, 'Mahti Mikko', 'Mighty Marco', 'Hän kuristi krokotiilin vain yhdellä nyrkillä!', 'He suffocated an alligator with only one fist!'),
(22, 6, 0, 'Sydämen Syke', 'Heart Stopper', 'Aina kun kortti kuolee, tämä kortti saa yhden voiman.', 'Whenever card dies, this card gains one power.'),
(23, 2, 2, 'Limaläjä', 'Smile Pile', 'Kun tämä kortti kuolee, se jakaantuu kahtia.', 'When this card dies, it splits in two.'),
(24, 4, 1, 'Epäonni Emmi', 'Unlycky Roseline', 'Kun tämä kortti kuolee, vaihda pakassasi olevien korttien hinta ja voima.', 'When this card dies, switch the cost and power of each card in your deck.'),
(25, 4, 2, 'Vanessa Valas', 'Winsley Whale', 'Kun nostat tämän kortin, se saa kuusi voimaa.', 'When you draw this card, it gains six power.'),
(26, 3, 3, 'Hai Ahmatti', 'Shark Raider', 'Kun nostat tämän kortin, tuplaa sen voima.', 'When you draw this card, double its power.'),
(27, 4, 2, 'Emäalus', 'Mothership', 'Kun tämä kortti kuolee, se synnyttää kaksi isä kalliota.', 'When this card dies, it gives birth to two hillmakers.'),
(28, 2, 2, 'Kasvattaja Katri', 'Growing Glory', 'Kun tämä kortti kuolee, vanilla kortit pakassasi saavat kaksi voimaa.', 'When this card dies, the vanilla cards in your deck gain two power.'),
(29, 1, 2, 'Yksinhuolt Hilda', 'Single Mom Hilda', 'Kun tämä kortti kuolee, se synnyttää lapsen vastustajasi pakkaan.', 'When this card dies, it shuffles a child into your opponent\'s deck.'),
(30, 6, 0, 'Enkeli Elias', 'Angel Alex', 'Aina kun vastustajasi kortti saa voimaa, tämä kortti saa yhden voiman.', 'Whenever your opponent\'s card gains power, this card gains one power.'),
(31, 5, 8, 'Ilkeä Iiro', 'Evil Michael', 'Vuoron lopussa, ota kallein kortti vastustajasi kädestä.', 'At the end of turn, take the most expensive card from your opponent\'s hand.'),
(32, 2, 5, 'Merirosvo Merja', 'Pirate Melina', 'Kun tämä kortti kuolee, kortit vastustajasi pakassa saavat yhden voiman.', 'When this card dies, each card in your opponent\'s deck gains one power.'),
(33, 6, 0, 'Äiti Kallio', 'Hillmother', 'Kun tämä kortti kuolee, se synnyttää kymmenen isä kalliota.', 'When this card dies, it gives birth to ten hillmakers.'),
(34, 5, 10, 'Lihalössi', 'Fat Acid', 'Tätä korttia ei voi nostaa pakasta.', 'This card cannot be drawn from deck.'),
(35, 2, 3, 'Pistävä Pinja', 'Hardcore Miriam', 'Kun tämä kortti tappaa vastustajan kortin taistelussa, se saa sen alkuperäisen voiman.', 'When this card kills an opponent\'s card in fight, it gains its original power.'),
(36, 1, 1, 'Toivon Kipinä', 'Ceded Hope', 'Kun tämä kortti kuolee, pelin lopussa -kortit saavat kolme voimaa.', 'When this card dies, end of game -cards gains gain three power.'),
(37, 2, 4, 'Syöpä Senni', 'Cancer Caitlin', 'Pelin lopussa, tämän kortin voima tippuu nollaan.', 'At the end of game, this card\'s power drops to zero.'),
(38, 5, 6, 'Elämän Lilja', 'Living Odessa', 'Kun tämä kortti kuolee, vastustajasi korttien voima palaa alkuperäiseksi.', 'When this card dies, your opponent\'s cards have their power returned to base power.'),
(39, 1, 0, 'Peruna', 'Potato', 'Vuoron lopussa, tämä kortti saa yhden voiman.', 'At the end of turn, this card gains one power.'),
(40, 2, 2, 'Farmari Fanni', 'Farmer Freya', 'Kun tämä kortti kuolee, se istuttaa kaksi perunaa vastustajasi pakkaan.', 'When this card dies, it plants two potatoes into your opponent\'s deck.'),
(10000, 99999, 99999, '----------', '----------', '----------', '----------'),
(10001, 1, 61, 'Vuori Karhu', 'Mountain Bear', 'Jos tämä kortti on pakassasi, se syö muut korttisi.', 'If this card is in your deck, it eats your other cards'),
(10002, 1, 2, 'Variksen Karhu', 'Scarebear', 'Kun pelaat tämän kortin, naamioi se vuorikarhuksi.', 'When you play this card, camouflage it as a mountain bear.'),
(10004, 1, 2, 'Suklaa Syöppö', 'Choko Boy', 'Vuoron lopussa sekoita kätesi pakkaasi ja nosta kolme korttia vastustajasi pakasta.', 'At the end of turn, shuffle your hand into the deck and draw three cards from opponent\'s deck.'),
(10006, 1, 2, 'Verokarhu', 'Tax Bear', 'Vuoron lopussa, nosta vastustajasi kädessä olevan kortin hintaaa yhdella.', 'At the end of turn, increase the cost of a card in your opponent\'s hand by one.'),
(10007, 1, 2, 'Rulla Roosa', 'Skating Skylar', 'Jokainen pelaaja saa yhden vähemmän manaa vuoron alussa.', 'Each player gains one less mana at the start of turn.'),
(10008, 1, 2, '', '', 'Vuoron lopussa, kortit pakassasi saavat yhden voiman.', 'At the end of turn, cards in your deck gain one power.'),
(10009, 1, 2, 'Sota Majava', 'Militant Beaver', 'Vastustajasi ei voi pelata kortteja, jotka maksavat vähemmän kuin kaksi.', 'Your opponent cannot play cards that cost less than two.'),
(20000, 99999, 99999, '----------', '----------', '----------', '----------'),
(20001, 2, 1, 'Aivolohko', 'Fill Shard', 'Jos tämä kortti on haudassa, se palaa vuoron lopussa kentälle.', 'If this card is in the grave, it comes back to field at the end of turn.'),
(20002, 2, 5, 'Lasimies', 'Glass Man', 'Kun tämä kortti hyökkää, puolita sen voima.', 'When this card attacks, half its power.'),
(20003, 2, 3, 'Kokoomus Koskinen', 'Politician Pascal', 'Nostat vastustajasi pakasta.', 'You draw from your opponent\'s deck.'),
(20005, 2, 3, 'Nuorekas Nelli', 'Juvenile Judie', 'Kun pelaat tämän kortin, naamioi se lapseksi.', 'When you play this card, camouflage it as a child.'),
(20006, 2, 4, 'Velhokala', 'Magical Fish', 'Kun pelaat tämän kortin, sekoita se ja kätesi pakkaasi ja nosta kolme uutta korttia.', 'When you play this card, shuffle it and your hand into the deck and draw three new cards.'),
(20007, 2, 2, 'Kuvaaja Keijo', 'Camera Bill', 'Kun tuplaat tämän kortin voiman, tuplaa se kahdesti sen sijaan.', 'When you double this card\'s power, double it twice instead.'),
(20008, 2, 4, 'Viiksi Elmeri', 'Mustache Elon', 'Kun tämä kortti kuolee, tuhoa pakkasi päällimmäinen kortti.', 'When this card dies, destroy the top card of your deck.'),
(20009, 2, -1, 'Äiti Annukka', 'Mother Alessa', 'Pelin alussa, tämä kortti saa kaksi voimaa jokaisesta yksi-maksuisesta kortista pakassasi.', 'At the start of game, this card gains two power for each one-cost card in your deck.'),
(20010, 2, 2, 'Robotti Hydra', 'Metal Hydra', 'Kun tämä kortti kuolee, kortit pakassasi saavat yhden voiman.', 'When this card dies, cards in your dekc gaind one power.'),
(20011, 2, 3, 'Manalan Koiranpentu', 'Puppy Cerberus', 'Kun tämä kortti tuhoutuu pakastasi, pistä se kentälle.', 'When this card is destroyed from your deck, put it into the field.'),
(30000, 99999, 99999, '----------', '----------', '----------', '----------'),
(30002, 3, 4, 'Totinen Tilda', 'Serious Serenity', 'Tämä kortti voi tappaa kuolemattomat kortit.', 'This card can kill immmortal cards.'),
(30003, 3, 2, 'Tuhma Siskopuoli', 'Bratty Stepsister', 'Kun tämä kortti taistelee, tuhoa vastustajasi pakan päällimmäinen kortti.', 'When this card fights, destroy the top card of your opponent\'s deck.'),
(30004, 3, 1, 'Vakuutus Veeti', 'Insurance Imran', 'Kun tämä kortti kuolee, tuplaa kädessäsi olevan kortin voima.', 'When this card dies, double the power of a card in your hand.'),
(30005, 3, 3, 'Itserakas Ilkka', 'Selfish Sebastian', 'Vuoron lopussa, tee kopio tästä kortista.', 'At the end of turn, duplicate this card.'),
(40000, 99999, 99999, '----------', '----------', '----------', '----------'),
(40002, 4, 6, 'Mahti Mikko', 'Mighty Mark', 'Vuoron lopussa, sekoita kätesi pakkaasi ja nosta kaksi vahvinta korttia.', 'At the end of turn, shuffle your hand into the deck and draw the two most powerful cards.'),
(40003, 4, 4, 'Imettäjä Iiris', 'Wetnurse Wendy', 'Pelin alussa, tämän kortin hinta laskee yhdella jokaisesta yksi-maksuisesta kortista pakassasi.', 'At the start of game, this card\'s cost decreases by one for each one-cost card in your deck.'),
(40004, 4, 6, 'Isä Iivari', 'Father Isaac', 'Kun pelaat tämän kortin, jaa sen voima kädessäsi oleville korteille.', 'When you play this card, give its power to the cards in your hand.'),
(40005, 4, 3, 'Aika Jaska', 'Time Jack', 'Kun tämä kortti kuolee, vuoro päättyy.', 'When this card dies, the turn ends.'),
(40006, 4, 4, 'Huijari Puijari', 'Sneaky Shoemaker', 'Kun pelaat tämän kortin, vaihda se vastustajasi voimakkaimpaan korttiin.', 'When you play this card, switch it with your opponent\'s most powerful card.'),
(40008, 4, 6, 'Ikuinen Kuningas', 'Eternal King', 'Pelaajat eivät voi nostaa kortteja.', 'Players cannot draw cards.'),
(50000, 99999, 99999, '----------', '----------', '----------', '----------'),
(50002, 5, 4, 'Norsu Nokia', 'Phant Nokia', 'Kun tämä kortti kuolee, tuhoa vastustajasi pakan kaksi päällimmäistä korttia.', 'When this card dies, destroy the top two cards of your opponent\'s deck.'),
(50003, 5, 12, 'Enkeli Elias', 'Angel Alex', 'Kun nostat tämän kortin ensimmäisen vuoron jälkeen, sekoita muut kortit kädestäsi pakkaasi.', 'When you draw this card after first turn, shuffle the other cards from your hand into your deck.'),
(50004, 5, 8, 'Manalan Vahtikoira', 'Watchdog Cerberus', 'Kun tämä kortti tuhoutuu pakastasi, pistä se käteesi.', 'When this card is destroyed from your deck, put it into your hand.'),
(50005, 5, 8, 'Isoisä Ilkka', 'Grandfather Sebastian', 'Kun pelaat tämän kortin, naamioi se itsekkääksi Ilkaksi.', 'When you play this, camouflage it as selfish Sebastian.'),
(50006, 5, 4, 'Savolaiset Kaksoset', 'Chimera Sisters', 'Kun tämä kortti kuolee, se jakaantu kahtia.', 'When this card dies, it splits in two.'),
(50007, 5, 8, 'Jätti Vartija', 'Ogre Gatekeeper', 'Pelaajat eivät voi pelata kortteja, jotka maksavat enemmän kuin viisi.', 'Players cannot play cards that cost more than five.'),
(60000, 99999, 99999, '----------', '----------', '----------', '----------'),
(60001, 6, 12, 'Elämän Lilja', 'Living Odessa', 'Kun tämä kortti kuolee, tuhoa pakkasi.', 'When this card dies, destroy your deck.'),
(60003, 6, 13, 'Neljä Ratsastajaa', 'Four Horseman', 'Kun nostat tämän kortin ensimmäisen vuoron jälkeen, sekoita kopio siitä pakkaasi.', 'When you draw this card after the first turn, shuffle a copy of it into your deck.'),
(60004, 6, 10, 'Hornanportti', 'Skull Wyvern', 'Pelin lopussa, palauta voimakkaimmat kortit haudastasi kentälle.', 'At the end of game, return the most powerful cards from your grave to the field.'),
(60005, 6, 10, 'Kommunisti Ylijumalat', 'Communist Overlords', 'Jos vastustajasi pakassa ei ole kortteja, tämän kortin hinta on nolla.', 'If your opponent has no cards in their deck, this card\'s cost is zero.'),
(60006, 6, 8, 'Korvek', 'Korvec', 'Kun tämä kortti taistelee, se saa kaksi voimaa.', 'When this card fights, it gains two power.'),
(60007, 6, 12, 'Uni Lohkari', 'Dream Dragon', 'Kun vaihdat tämän kortin hinnan ja voiman, pistä se kentälle.', 'When you switch this card\'s cost and power, put it into the field.');

-- --------------------------------------------------------

--
-- Table structure for table `card_effect`
--

CREATE TABLE `card_effect` (
  `owner_id` int(11) NOT NULL,
  `trigger_condition` varchar(16) NOT NULL,
  `trigger_zone` int(11) NOT NULL,
  `effect` varchar(24) NOT NULL,
  `value` int(11) DEFAULT NULL,
  `restriction` varchar(16) DEFAULT NULL,
  `condition_1` varchar(24) DEFAULT NULL,
  `value_1` int(11) DEFAULT NULL,
  `condition_2` varchar(24) DEFAULT NULL,
  `value_2` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `card_effect`
--

INSERT INTO `card_effect` (`owner_id`, `trigger_condition`, `trigger_zone`, `effect`, `value`, `restriction`, `condition_1`, `value_1`, `condition_2`, `value_2`) VALUES
(0, 'end_of_game', 2, 'multiply_own_power', 2, NULL, NULL, NULL, NULL, NULL),
(1, 'end_of_turn', 2, 'multiply_own_power', 2, NULL, NULL, NULL, NULL, NULL),
(3, 'death', 2, 'spawn_card', 2, NULL, NULL, NULL, NULL, NULL),
(4, 'end_of_turn', 1, 'gain_power', 3, NULL, NULL, NULL, NULL, NULL),
(6, 'end_of_turn', 1, 'gain_power', -2, NULL, NULL, NULL, NULL, NULL),
(8, 'multiply_effect', 2, 'death', 2, NULL, NULL, NULL, NULL, NULL),
(8, 'multiply_effect', 2, 'whenever_death', 2, NULL, NULL, NULL, NULL, NULL),
(9, 'death', 2, 'gain_power', 1, NULL, 'where_cost_is', 0, NULL, NULL),
(12, 'end_of_turn', 1, 'gain_cost', -1, NULL, NULL, NULL, NULL, NULL),
(13, 'multiply_effect', 2, 'end_of_turn', 2, NULL, NULL, NULL, NULL, NULL),
(14, 'end_of_turn', 0, 'gain_power', 1, NULL, NULL, NULL, NULL, NULL),
(15, 'negate_effects', 2, 'death', NULL, NULL, NULL, NULL, NULL, NULL),
(15, 'negate_effects', 4, 'whenever_death', NULL, NULL, NULL, NULL, NULL, NULL),
(16, 'end_of_turn', 2, 'multiply_power', 2, NULL, 'all_targets', 1, NULL, NULL),
(17, 'play', 1, 'gain_cost', -2, NULL, 'where_location_is', 1, 'where_cost_is', 4),
(18, 'death', 2, 'draw', 1, NULL, 'from_opponent', NULL, NULL, NULL),
(19, 'death', 2, 'gain_power', 1, NULL, 'where_location_is', 2, 'where_owner_is', 1),
(22, 'whenever_death', 4, 'gain_power', 1, NULL, NULL, NULL, NULL, NULL),
(23, 'death', 2, 'split_card', 2, NULL, NULL, NULL, NULL, NULL),
(24, 'death', 2, 'stat_flip', NULL, NULL, 'where_location_is', 0, 'where_owner_is', 1),
(25, 'draw', 1, 'gain_power', 6, NULL, NULL, NULL, NULL, NULL),
(26, 'draw', 1, 'multiply_own_power', 2, NULL, NULL, NULL, NULL, NULL),
(27, 'death', 2, 'spawn_card', 1, NULL, 'amount', 2, NULL, NULL),
(28, 'death', 2, 'gain_power', 2, 'vanilla', 'where_location_is', 0, 'where_owner_is', 1),
(29, 'death', 2, 'spawn_card', 2, 'to_opponent', 'location', 0, NULL, NULL),
(30, 'whenever_power', 4, 'gain_power', 1, 'no_chain', 'when_player', 2, NULL, NULL),
(31, 'end_of_turn', 2, 'steal_card', 1, 'highest_cost', 'where_location_is', 1, NULL, NULL),
(32, 'death', 2, 'gain_power', 1, NULL, 'where_location_is', 0, 'where_owner_is', 2),
(33, 'death', 2, 'spawn_card', 1, NULL, 'amount', 10, 'power_change', -1),
(34, 'cannot_be_drawn', 0, 'always', NULL, NULL, NULL, NULL, NULL, NULL),
(35, 'got_kill', 2, 'gain_power', NULL, NULL, NULL, NULL, NULL, NULL),
(36, 'death', 2, 'gain_power', 3, 'end_of_game', 'where_location_is', 4, NULL, NULL),
(37, 'end_of_game', 2, 'multiply_own_power', 0, NULL, NULL, NULL, NULL, NULL),
(38, 'death', 2, 'default_power', NULL, NULL, 'where_owner_is', 2, NULL, NULL),
(39, 'end_of_turn', 4, 'gain_power', 1, NULL, NULL, NULL, NULL, NULL),
(40, 'death', 2, 'spawn_card', 39, 'to_opponent', 'location', 0, 'amount', 2);

-- --------------------------------------------------------

--
-- Table structure for table `card_instance`
--

CREATE TABLE `card_instance` (
  `instance_id` int(11) NOT NULL,
  `game_id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `base_id` int(11) NOT NULL,
  `variant_id` int(11) NOT NULL DEFAULT 0,
  `zone_id` int(11) NOT NULL,
  `card_slot` int(11) NOT NULL,
  `cost_change` int(11) NOT NULL DEFAULT 0,
  `power_change` int(11) NOT NULL DEFAULT 0,
  `attacks` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `card_instance`
--

INSERT INTO `card_instance` (`instance_id`, `game_id`, `player_id`, `base_id`, `variant_id`, `zone_id`, `card_slot`, `cost_change`, `power_change`, `attacks`) VALUES
(1, 1, 39727276, 2, 0, 3, 2, 0, -1, 0),
(2, 1, 39727276, 27, 0, 1, 3, 0, 0, 0),
(3, 1, 39727276, 40, 0, 2, 1, 0, 0, 0),
(4, 1, 39727276, 30, 0, 1, 1, 0, 26, 0),
(5, 1, 39727276, 24, 0, 0, 1, 0, 0, 0),
(6, 1, 39727276, 35, 0, 2, 2, 0, 0, 0),
(7, 1, 39727276, 38, 0, 1, 2, 0, 0, 0),
(8, 1, 39727276, 9, 0, 3, 3, 0, -1, 0),
(9, 1, 39727276, 29, 0, 0, 2, 0, 0, 0),
(10, 1, 39727276, 32, 0, 3, 1, 0, -5, 0),
(11, 1, 39727276, 39, 0, 0, 3, 0, 6, 0),
(12, 1, 39727276, 23, 0, 2, 3, 0, 0, 0),
(14, 1, 63934637, 9, 0, 0, 2, 0, 2, 0),
(15, 1, 63934637, 3, 0, 0, 3, 0, 1, 0),
(16, 1, 63934637, 1, 0, 2, 1, 0, 30, 0),
(17, 1, 63934637, 22, 0, 0, 1, 0, 7, 0),
(18, 1, 63934637, 6, 0, 1, 1, 0, -5, 0),
(19, 1, 63934637, 35, 0, 2, 5, 0, 1, 0),
(20, 1, 63934637, 30, 0, 1, 2, 0, 7, 0),
(21, 1, 63934637, 39, 0, 2, 4, 0, 7, 0),
(22, 1, 63934637, 18, 0, 2, 3, 0, 0, 0),
(23, 1, 63934637, 5, 0, 2, 2, 0, 0, 0),
(24, 1, 63934637, 36, 0, 1, 3, 0, 1, 0),
(25, 1, 63934637, 23, 0, 3, 1, 0, -2, 0),
(26, 1, 63934637, 23, 0, 3, 3, -2, -2, 0),
(27, 1, 63934637, 23, 0, 3, 2, -2, -2, 0),
(29, 2, 39727276, 2, 0, 1, 2, 0, 0, 0),
(30, 2, 39727276, 32, 0, 1, 1, 0, 0, 0),
(31, 2, 39727276, 9, 0, 0, 3, 0, 0, 0),
(32, 2, 39727276, 30, 0, 0, 1, 0, 15, 0),
(33, 2, 39727276, 40, 0, 2, 2, 0, 0, 0),
(34, 2, 39727276, 35, 0, 2, 5, 0, 0, 0),
(35, 2, 39727276, 23, 0, 3, 1, 0, -2, 0),
(36, 2, 39727276, 22, 0, 0, 2, 0, 6, 0),
(37, 2, 39727276, 29, 0, 2, 1, 0, 0, 0),
(38, 2, 39727276, 24, 0, 1, 3, 0, 0, 0),
(39, 2, 39727276, 39, 0, 2, 3, 0, 6, 0),
(40, 2, 39727276, 27, 0, 2, 4, 0, 0, 0),
(42, 2, 63934637, 35, 0, 1, 1, 0, 0, 0),
(43, 2, 63934637, 30, 0, 0, 2, 0, 12, 0),
(44, 2, 63934637, 3, 0, 2, 5, 0, 0, 0),
(45, 2, 63934637, 18, 0, 2, 2, 0, 0, 0),
(46, 2, 63934637, 9, 0, 1, 3, 0, 0, 0),
(47, 2, 63934637, 5, 0, 2, 3, 0, 0, 0),
(48, 2, 63934637, 23, 0, 3, 1, 0, -2, 0),
(49, 2, 63934637, 6, 0, 2, 1, 0, -2, 0),
(50, 2, 63934637, 36, 0, 0, 3, 0, 0, 0),
(51, 2, 63934637, 1, 0, 2, 4, 0, 14, 0),
(52, 2, 63934637, 22, 0, 0, 1, 0, 6, 0),
(53, 2, 63934637, 39, 0, 1, 2, 0, 6, 0),
(54, 2, 63934637, 23, 0, 3, 2, -2, -2, 0),
(55, 2, 63934637, 23, 0, 3, 3, -2, -2, 0),
(56, 2, 39727276, 23, 0, 3, 2, -2, -2, 0),
(57, 2, 39727276, 23, 0, 3, 3, -2, -2, 0),
(59, 3, 39727276, 9, 0, 0, 1, 0, 1, 0),
(60, 3, 39727276, 39, 0, 1, 2, 0, 7, 0),
(61, 3, 39727276, 40, 0, 3, 7, 0, -2, 0),
(62, 3, 39727276, 24, 0, 0, 2, 0, 1, 0),
(63, 3, 39727276, 35, 0, 3, 6, 0, -3, 0),
(64, 3, 39727276, 30, 0, 1, 1, 0, 29, 0),
(65, 3, 39727276, 27, 0, 3, 8, 0, -2, 0),
(66, 3, 39727276, 29, 0, 3, 4, 0, -2, 0),
(67, 3, 39727276, 23, 0, 3, 1, 0, -2, 0),
(68, 3, 63934637, 32, 0, 3, 2, 0, -5, 0),
(69, 3, 39727276, 2, 0, 3, 5, 0, -1, 0),
(70, 3, 39727276, 22, 0, 2, 1, 0, 2, 0),
(72, 3, 63934637, 5, 0, 3, 7, 0, -4, 0),
(73, 3, 63934637, 30, 0, 1, 1, 0, 30, 0),
(74, 3, 63934637, 36, 0, 1, 1, 0, 0, 0),
(75, 3, 63934637, 23, 0, 3, 3, 0, -2, 0),
(76, 3, 63934637, 22, 0, 3, 8, 0, 1, 0),
(77, 3, 63934637, 1, 0, 0, 5, 0, 0, 0),
(78, 3, 63934637, 35, 0, 0, 2, 0, 0, 0),
(79, 3, 63934637, 9, 0, 2, 1, 0, 0, 0),
(80, 3, 63934637, 3, 0, 0, 3, 0, 0, 0),
(81, 3, 63934637, 6, 0, 3, 4, 0, -5, 0),
(82, 3, 63934637, 18, 0, 3, 1, 0, -1, 0),
(83, 3, 63934637, 39, 0, 2, 2, 0, 4, 0),
(84, 3, 39727276, 23, 0, 3, 2, -2, -2, 0),
(85, 3, 39727276, 23, 0, 3, 3, -2, -2, 0),
(86, 3, 63934637, 2, 0, 0, 4, 0, 0, 0),
(87, 3, 63934637, 23, 0, 3, 5, -2, -2, 0),
(88, 3, 63934637, 23, 0, 3, 6, -2, -2, 0),
(89, 3, 63934637, 39, 0, 0, 1, 0, 2, 0),
(90, 3, 63934637, 39, 0, 0, 6, 0, 2, 0),
(91, 3, 39727276, 1, 0, 3, 10, 0, -2, 0),
(92, 3, 39727276, 1, 0, 3, 9, 0, -2, 0);

-- --------------------------------------------------------

--
-- Table structure for table `dev_card`
--

CREATE TABLE `dev_card` (
  `id` int(11) NOT NULL,
  `cost` int(11) NOT NULL,
  `power` int(11) NOT NULL,
  `finnish_name` varchar(32) NOT NULL,
  `english_name` varchar(32) NOT NULL,
  `finnish_effects` varchar(96) NOT NULL,
  `english_effects` varchar(96) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `dev_card`
--

INSERT INTO `dev_card` (`id`, `cost`, `power`, `finnish_name`, `english_name`, `finnish_effects`, `english_effects`) VALUES
(0, 3, 4, 'Viinivalli', 'Wine Wabble', 'Pelin lopussa, tuplaa tämän kortin voima.', 'At the end of game, double this card\'s power.'),
(1, 1, 2, 'Isä Kallio', 'Hillmaker', 'Jos tämä kortti on kentällä, tuplaa sen voima vuoron lopussa.', 'If this card is on the field, double its power at the end of turn.'),
(2, 0, 1, 'Lapsi', 'Child', 'Kostan äitini puolesta!', 'I\'ll revenge my mom!'),
(3, 3, 4, 'Märkä Marjatta', 'Moist Monica', 'Kun tämä kortti kuolee, se synnyttää lapsen.', 'When this card dies, it gives birth to a child.'),
(4, 6, 1, 'Musta Jeesus', 'Jesus Black', 'Jos tämä kortti on kädessäsi, se saa kolme voimaa vuoron lopussa.', 'If this card is in your hand, it gains three power at the end of turn.'),
(5, 2, 4, 'Valonviejä', 'Spot Taker', 'Mustat miehet tanssii yöllä, ja kaikki tietää sen.', 'Black revelers dance at night, and everyone knows it.'),
(6, 2, 5, 'Lumiukko', 'Snowman', 'Jos tämä kortti on kädessäsi, se menettää kaksi voimaa vuoron lopussa.', 'If this card is in your hand, it loses two power at the end of turn.'),
(7, 1, 3, 'Futarityttö Linnea', 'Football Girl Linda', 'Koulun paras futiksen pelaaja.', 'Best football player in the school.'),
(8, 3, 3, 'Kuoleman Tuuli', 'Death God Tuuli', 'Kuollessa -kyvyt tapahtuvat kahdesti.', 'Dying effects happen twice.'),
(9, 0, 1, 'Nakkivene', 'Sausage Boat', 'Kun tämä kortti kuolee, muut nolla-maksuiset kortit saavat yhden voiman.', 'When this card dies, other zero-cost cards gain one power'),
(10, 3, 5, 'Vihreä Ninja', 'Emerald Shogun', 'Hän palauttaa vastustajan voiman takaisin kaksinkertaisena.', 'He returns the opponent\'s power back in double.'),
(11, 5, 9, 'Veitsi Veikko', 'Knife  Kevin', 'Hänen veitsiään ei voi väistää kukaan.', 'No one can evade the speed of his knives.'),
(12, 10, 16, 'Tulevan Luoja', 'Future Anomaly', 'Jos tämä kortti on kädessäsi, sen hinta laskee yhdellä vuoron lopussa.', 'If this card is in your hand, it cost decreases by one at the end of turn.'),
(13, 4, 5, 'Henki Mira', 'Yokai Mirai', 'Vuoron lopussa -kyvyt tapahtuvat kahdesti.', 'End of turn -effects happen twice.'),
(14, 1, 2, 'Ananas Mies', 'Pineapple Man', 'Jos tämä kortti on pakassasi, se saa vuoron lopussa yhden voiman.', 'If this card is in your deck, it gains one power at the end of turn.'),
(15, 4, 6, 'Herättävä Henna', 'Insomniac Iris', 'Kuollessa -kyvyt eivät toimi.', 'Dying effects do not work.'),
(16, 5, 2, 'Bitcoin Keisari', 'Don Bitcoin', 'Vuoron lopussa, tuplaa kädessäsi olevien korttien voima.', 'At the end of turn, double the power of each card in your hand.'),
(17, 3, 2, 'Kiinan Tiikeri', 'Paper Tiger', 'Kun pelaat tämän kortin, neljä-maksuisten korttien hinta käsissä laskee kahdella.', 'When you play this card, four-cost cards in hands have their cost reduced by two.'),
(18, 1, 1, 'Toveri Otso', 'Comrade Winnie', 'Kun tämä kortti kuolee, nosta kortti vastustajasi pakasta.', 'When this card dies, draw a card from your opponent\'s deck.'),
(19, 4, 5, 'Rohkea Niilo', 'Brave Nick', 'Kun tämä kortti kuolee, muut korttisi saavat yhden voiman.', 'When this card dies, your other cards gain one power.'),
(20, 6, 12, 'Mipopi Dinomuoto', 'Mipopi Dinoform', 'Uskotko nyt dinosauruksiin, Peitse?', 'Do you believe in dinosaurs now, Pent?'),
(21, 4, 7, 'Mahti Mikko', 'Mighty Marco', 'Hän kuristi krokotiilin vain yhdellä nyrkillä!', 'He suffocated an alligator with only one fist!'),
(22, 6, 0, 'Sydämen Syke', 'Heart Stopper', 'Aina kun kortti kuolee, tämä kortti saa yhden voiman.', 'Whenever card dies, this card gains one power.'),
(23, 2, 2, 'Limaläjä', 'Smile Pile', 'Kun tämä kortti kuolee, se jakaantuu kahtia.', 'When this card dies, it splits in two.'),
(24, 4, 1, 'Epäonni Emmi', 'Unlycky Roseline', 'Kun tämä kortti kuolee, vaihda pakassasi olevien korttien hinta ja voima.', 'When this card dies, switch the cost and power of each card in your deck.'),
(25, 4, 2, 'Vanessa Valas', 'Winsley Whale', 'Kun nostat tämän kortin, se saa kuusi voimaa.', 'When you draw this card, it gains six power.'),
(26, 3, 3, 'Hai Ahmatti', 'Shark Raider', 'Kun nostat tämän kortin, tuplaa sen voima.', 'When you draw this card, double its power.'),
(27, 4, 2, 'Emäalus', 'Mothership', 'Kun tämä kortti kuolee, se synnyttää kaksi isä kalliota.', 'When this card dies, it gives birth to two hillmakers.'),
(28, 2, 2, 'Kasvattaja Katri', 'Growing Glory', 'Kun tämä kortti kuolee, vanilla kortit pakassasi saavat kaksi voimaa.', 'When this card dies, the vanilla cards in your deck gain two power.'),
(29, 1, 2, 'Yksinhuolt Hilda', 'Single Mom Hilda', 'Kun tämä kortti kuolee, se synnyttää lapsen vastustajasi pakkaan.', 'When this card dies, it shuffles a child into your opponent\'s deck.'),
(30, 6, 0, 'Enkeli Elias', 'Angel Alex', 'Aina kun vastustajasi kortti saa voimaa, tämä kortti saa yhden voiman.', 'Whenever your opponent\'s card gains power, this card gains one power.'),
(31, 5, 8, 'Ilkeä Iiro', 'Evil Michael', 'Vuoron lopussa, ota kallein kortti vastustajasi kädestä.', 'At the end of turn, take the most expensive card from your opponent\'s hand.'),
(32, 2, 5, 'Merirosvo Merja', 'Pirate Melina', 'Kun tämä kortti kuolee, kortit vastustajasi pakassa saavat yhden voiman.', 'When this card dies, each card in your opponent\'s deck gains one power.'),
(33, 6, 0, 'Äiti Kallio', 'Hillmother', 'Kun tämä kortti kuolee, se synnyttää kymmenen isä kalliota.', 'When this card dies, it gives birth to ten hillmakers.'),
(34, 5, 10, 'Lihalössi', 'Fat Acid', 'Tätä korttia ei voi nostaa pakasta.', 'This card cannot be drawn from deck.'),
(35, 2, 3, 'Pistävä Pinja', 'Hardcore Miriam', 'Kun tämä kortti tappaa vastustajan kortin taistelussa, se saa sen alkuperäisen voiman.', 'When this card kills an opponent\'s card in fight, it gains its original power.'),
(36, 1, 1, 'Toivon Kipinä', 'Ceded Hope', 'Kun tämä kortti kuolee, pelin lopussa -kortit saavat kolme voimaa.', 'When this card dies, end of game -cards gains gain three power.'),
(37, 2, 4, 'Syöpä Senni', 'Cancer Caitlin', 'Pelin lopussa, tämän kortin voima tippuu nollaan.', 'At the end of game, this card\'s power drops to zero.'),
(38, 5, 6, 'Elämän Lilja', 'Living Odessa', 'Kun tämä kortti kuolee, vastustajasi korttien voima palaa alkuperäiseksi.', 'When this card dies, your opponent\'s cards have their power returned to base power.'),
(39, 1, 0, 'Peruna', 'Potato', 'Vuoron lopussa, tämä kortti saa yhden voiman.', 'At the end of turn, this card gains one power.'),
(40, 2, 2, 'Farmari Fanni', 'Farmer Freya', 'Kun tämä kortti kuolee, se istuttaa kaksi perunaa vastustajasi pakkaan.', 'When this card dies, it plants two potatoes into your opponent\'s deck.'),
(10000, 99999, 99999, '----------', '----------', '----------', '----------'),
(10001, 1, 61, 'Vuori Karhu', 'Mountain Bear', 'Jos tämä kortti on pakassasi, se syö muut korttisi.', 'If this card is in your deck, it eats your other cards'),
(10002, 1, 2, 'Variksen Karhu', 'Scarebear', 'Kun pelaat tämän kortin, naamioi se vuorikarhuksi.', 'When you play this card, camouflage it as a mountain bear.'),
(10004, 1, 2, 'Suklaa Syöppö', 'Choko Boy', 'Vuoron lopussa sekoita kätesi pakkaasi ja nosta kolme korttia vastustajasi pakasta.', 'At the end of turn, shuffle your hand into the deck and draw three cards from opponent\'s deck.'),
(10006, 1, 2, 'Verokarhu', 'Tax Bear', 'Vuoron lopussa, nosta vastustajasi kädessä olevan kortin hintaaa yhdella.', 'At the end of turn, increase the cost of a card in your opponent\'s hand by one.'),
(10007, 1, 2, 'Rulla Roosa', 'Skating Skylar', 'Jokainen pelaaja saa yhden vähemmän manaa vuoron alussa.', 'Each player gains one less mana at the start of turn.'),
(10008, 1, 2, '', '', 'Vuoron lopussa, kortit pakassasi saavat yhden voiman.', 'At the end of turn, cards in your deck gain one power.'),
(10009, 1, 2, 'Sota Majava', 'Militant Beaver', 'Vastustajasi ei voi pelata kortteja, jotka maksavat vähemmän kuin kaksi.', 'Your opponent cannot play cards that cost less than two.'),
(20000, 99999, 99999, '----------', '----------', '----------', '----------'),
(20001, 2, 1, 'Aivolohko', 'Fill Shard', 'Jos tämä kortti on haudassa, se palaa vuoron lopussa kentälle.', 'If this card is in the grave, it comes back to field at the end of turn.'),
(20002, 2, 5, 'Lasimies', 'Glass Man', 'Kun tämä kortti hyökkää, puolita sen voima.', 'When this card attacks, half its power.'),
(20003, 2, 3, 'Kokoomus Koskinen', 'Politician Pascal', 'Nostat vastustajasi pakasta.', 'You draw from your opponent\'s deck.'),
(20005, 2, 3, 'Nuorekas Nelli', 'Juvenile Judie', 'Kun pelaat tämän kortin, naamioi se lapseksi.', 'When you play this card, camouflage it as a child.'),
(20006, 2, 4, 'Velhokala', 'Magical Fish', 'Kun pelaat tämän kortin, sekoita se ja kätesi pakkaasi ja nosta kolme uutta korttia.', 'When you play this card, shuffle it and your hand into the deck and draw three new cards.'),
(20007, 2, 2, 'Kuvaaja Keijo', 'Camera Bill', 'Kun tuplaat tämän kortin voiman, tuplaa se kahdesti sen sijaan.', 'When you double this card\'s power, double it twice instead.'),
(20008, 2, 4, 'Viiksi Elmeri', 'Mustache Elon', 'Kun tämä kortti kuolee, tuhoa pakkasi päällimmäinen kortti.', 'When this card dies, destroy the top card of your deck.'),
(20009, 2, -1, 'Äiti Annukka', 'Mother Alessa', 'Pelin alussa, tämä kortti saa kaksi voimaa jokaisesta yksi-maksuisesta kortista pakassasi.', 'At the start of game, this card gains two power for each one-cost card in your deck.'),
(20010, 2, 2, 'Robotti Hydra', 'Metal Hydra', 'Kun tämä kortti kuolee, kortit pakassasi saavat yhden voiman.', 'When this card dies, cards in your dekc gaind one power.'),
(20011, 2, 3, 'Manalan Koiranpentu', 'Puppy Cerberus', 'Kun tämä kortti tuhoutuu pakastasi, pistä se kentälle.', 'When this card is destroyed from your deck, put it into the field.'),
(30000, 99999, 99999, '----------', '----------', '----------', '----------'),
(30002, 3, 4, 'Totinen Tilda', 'Serious Serenity', 'Tämä kortti voi tappaa kuolemattomat kortit.', 'This card can kill immmortal cards.'),
(30003, 3, 2, 'Tuhma Siskopuoli', 'Bratty Stepsister', 'Kun tämä kortti taistelee, tuhoa vastustajasi pakan päällimmäinen kortti.', 'When this card fights, destroy the top card of your opponent\'s deck.'),
(30004, 3, 1, 'Vakuutus Veeti', 'Insurance Imran', 'Kun tämä kortti kuolee, tuplaa kädessäsi olevan kortin voima.', 'When this card dies, double the power of a card in your hand.'),
(30005, 3, 3, 'Itserakas Ilkka', 'Selfish Sebastian', 'Vuoron lopussa, tee kopio tästä kortista.', 'At the end of turn, duplicate this card.'),
(40000, 99999, 99999, '----------', '----------', '----------', '----------'),
(40002, 4, 6, 'Mahti Mikko', 'Mighty Mark', 'Vuoron lopussa, sekoita kätesi pakkaasi ja nosta kaksi vahvinta korttia.', 'At the end of turn, shuffle your hand into the deck and draw the two most powerful cards.'),
(40003, 4, 4, 'Imettäjä Iiris', 'Wetnurse Wendy', 'Pelin alussa, tämän kortin hinta laskee yhdella jokaisesta yksi-maksuisesta kortista pakassasi.', 'At the start of game, this card\'s cost decreases by one for each one-cost card in your deck.'),
(40004, 4, 6, 'Isä Iivari', 'Father Isaac', 'Kun pelaat tämän kortin, jaa sen voima kädessäsi oleville korteille.', 'When you play this card, give its power to the cards in your hand.'),
(40005, 4, 3, 'Aika Jaska', 'Time Jack', 'Kun tämä kortti kuolee, vuoro päättyy.', 'When this card dies, the turn ends.'),
(40006, 4, 4, 'Huijari Puijari', 'Sneaky Shoemaker', 'Kun pelaat tämän kortin, vaihda se vastustajasi voimakkaimpaan korttiin.', 'When you play this card, switch it with your opponent\'s most powerful card.'),
(40008, 4, 6, 'Ikuinen Kuningas', 'Eternal King', 'Pelaajat eivät voi nostaa kortteja.', 'Players cannot draw cards.'),
(50000, 99999, 99999, '----------', '----------', '----------', '----------'),
(50002, 5, 4, 'Norsu Nokia', 'Phant Nokia', 'Kun tämä kortti kuolee, tuhoa vastustajasi pakan kaksi päällimmäistä korttia.', 'When this card dies, destroy the top two cards of your opponent\'s deck.'),
(50003, 5, 12, 'Enkeli Elias', 'Angel Alex', 'Kun nostat tämän kortin ensimmäisen vuoron jälkeen, sekoita muut kortit kädestäsi pakkaasi.', 'When you draw this card after first turn, shuffle the other cards from your hand into your deck.'),
(50004, 5, 8, 'Manalan Vahtikoira', 'Watchdog Cerberus', 'Kun tämä kortti tuhoutuu pakastasi, pistä se käteesi.', 'When this card is destroyed from your deck, put it into your hand.'),
(50005, 5, 8, 'Isoisä Ilkka', 'Grandfather Sebastian', 'Kun pelaat tämän kortin, naamioi se itsekkääksi Ilkaksi.', 'When you play this, camouflage it as selfish Sebastian.'),
(50006, 5, 4, 'Savolaiset Kaksoset', 'Chimera Sisters', 'Kun tämä kortti kuolee, se jakaantu kahtia.', 'When this card dies, it splits in two.'),
(50007, 5, 8, 'Jätti Vartija', 'Ogre Gatekeeper', 'Pelaajat eivät voi pelata kortteja, jotka maksavat enemmän kuin viisi.', 'Players cannot play cards that cost more than five.'),
(60000, 99999, 99999, '----------', '----------', '----------', '----------'),
(60001, 6, 12, 'Elämän Lilja', 'Living Odessa', 'Kun tämä kortti kuolee, tuhoa pakkasi.', 'When this card dies, destroy your deck.'),
(60003, 6, 13, 'Neljä Ratsastajaa', 'Four Horseman', 'Kun nostat tämän kortin ensimmäisen vuoron jälkeen, sekoita kopio siitä pakkaasi.', 'When you draw this card after the first turn, shuffle a copy of it into your deck.'),
(60004, 6, 10, 'Hornanportti', 'Skull Wyvern', 'Pelin lopussa, palauta voimakkaimmat kortit haudastasi kentälle.', 'At the end of game, return the most powerful cards from your grave to the field.'),
(60005, 6, 10, 'Kommunisti Ylijumalat', 'Communist Overlords', 'Jos vastustajasi pakassa ei ole kortteja, tämän kortin hinta on nolla.', 'If your opponent has no cards in their deck, this card\'s cost is zero.'),
(60006, 6, 8, 'Korvek', 'Korvec', 'Kun tämä kortti taistelee, se saa kaksi voimaa.', 'When this card fights, it gains two power.'),
(60007, 6, 12, 'Uni Lohkari', 'Dream Dragon', 'Kun vaihdat tämän kortin hinnan ja voiman, pistä se kentälle.', 'When you switch this card\'s cost and power, put it into the field.');

-- --------------------------------------------------------

--
-- Table structure for table `dev_card_effect`
--

CREATE TABLE `dev_card_effect` (
  `owner_id` int(11) NOT NULL,
  `trigger_condition` varchar(16) NOT NULL,
  `trigger_zone` int(11) NOT NULL,
  `effect` varchar(24) NOT NULL,
  `value` int(11) DEFAULT NULL,
  `restriction` varchar(16) DEFAULT NULL,
  `condition_1` varchar(24) DEFAULT NULL,
  `value_1` int(11) DEFAULT NULL,
  `condition_2` varchar(24) DEFAULT NULL,
  `value_2` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `dev_card_effect`
--

INSERT INTO `dev_card_effect` (`owner_id`, `trigger_condition`, `trigger_zone`, `effect`, `value`, `restriction`, `condition_1`, `value_1`, `condition_2`, `value_2`) VALUES
(0, 'end_of_game', 2, 'multiply_own_power', 2, NULL, NULL, NULL, NULL, NULL),
(1, 'end_of_turn', 2, 'multiply_own_power', 2, NULL, NULL, NULL, NULL, NULL),
(3, 'death', 2, 'spawn_card', 2, NULL, NULL, NULL, NULL, NULL),
(4, 'end_of_turn', 1, 'gain_power', 3, NULL, NULL, NULL, NULL, NULL),
(6, 'end_of_turn', 1, 'gain_power', -2, NULL, NULL, NULL, NULL, NULL),
(8, 'multiply_effect', 2, 'death', 2, NULL, NULL, NULL, NULL, NULL),
(8, 'multiply_effect', 2, 'whenever_death', 2, NULL, NULL, NULL, NULL, NULL),
(9, 'death', 2, 'gain_power', 1, NULL, 'where_cost_is', 0, NULL, NULL),
(12, 'end_of_turn', 1, 'gain_cost', -1, NULL, NULL, NULL, NULL, NULL),
(13, 'multiply_effect', 2, 'end_of_turn', 2, NULL, NULL, NULL, NULL, NULL),
(14, 'end_of_turn', 0, 'gain_power', 1, NULL, NULL, NULL, NULL, NULL),
(15, 'negate_effects', 2, 'death', NULL, NULL, NULL, NULL, NULL, NULL),
(15, 'negate_effects', 4, 'whenever_death', NULL, NULL, NULL, NULL, NULL, NULL),
(16, 'end_of_turn', 2, 'multiply_power', 2, NULL, 'all_targets', 1, NULL, NULL),
(17, 'play', 1, 'gain_cost', -2, NULL, 'where_location_is', 1, 'where_cost_is', 4),
(18, 'death', 2, 'draw', 1, NULL, 'from_opponent', NULL, NULL, NULL),
(19, 'death', 2, 'gain_power', 1, NULL, 'where_location_is', 2, 'where_owner_is', 1),
(22, 'whenever_death', 4, 'gain_power', 1, NULL, NULL, NULL, NULL, NULL),
(23, 'death', 2, 'split_card', 2, NULL, NULL, NULL, NULL, NULL),
(24, 'death', 2, 'stat_flip', NULL, NULL, 'where_location_is', 0, 'where_owner_is', 1),
(25, 'draw', 1, 'gain_power', 6, NULL, NULL, NULL, NULL, NULL),
(26, 'draw', 1, 'multiply_own_power', 2, NULL, NULL, NULL, NULL, NULL),
(27, 'death', 2, 'spawn_card', 1, NULL, 'amount', 2, NULL, NULL),
(28, 'death', 2, 'gain_power', 2, 'vanilla', 'where_location_is', 0, 'where_owner_is', 1),
(29, 'death', 2, 'spawn_card', 2, 'to_opponent', 'location', 0, NULL, NULL),
(30, 'whenever_power', 4, 'gain_power', 1, 'no_chain', 'when_player', 2, NULL, NULL),
(31, 'end_of_turn', 2, 'steal_card', 1, 'highest_cost', 'where_location_is', 1, NULL, NULL),
(32, 'death', 2, 'gain_power', 1, NULL, 'where_location_is', 0, 'where_owner_is', 2),
(33, 'death', 2, 'spawn_card', 1, NULL, 'amount', 10, 'power_change', -1),
(34, 'cannot_be_drawn', 0, 'always', NULL, NULL, NULL, NULL, NULL, NULL),
(35, 'got_kill', 2, 'gain_power', NULL, NULL, NULL, NULL, NULL, NULL),
(36, 'death', 2, 'gain_power', 3, 'end_of_game', 'where_location_is', 4, NULL, NULL),
(37, 'end_of_game', 2, 'multiply_own_power', 0, NULL, NULL, NULL, NULL, NULL),
(38, 'death', 2, 'default_power', NULL, NULL, 'where_owner_is', 2, NULL, NULL),
(39, 'end_of_turn', 4, 'gain_power', 1, NULL, NULL, NULL, NULL, NULL),
(40, 'death', 2, 'spawn_card', 39, 'to_opponent', 'location', 0, 'amount', 2);

-- --------------------------------------------------------

--
-- Table structure for table `game`
--

CREATE TABLE `game` (
  `id` int(11) NOT NULL,
  `starting_player` int(11) DEFAULT NULL,
  `turn_number` int(11) DEFAULT 1,
  `turn_started_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `turn_lasted` int(11) NOT NULL DEFAULT 0,
  `winner` int(11) DEFAULT NULL,
  `started_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `game`
--

INSERT INTO `game` (`id`, `starting_player`, `turn_number`, `turn_started_at`, `turn_lasted`, `winner`, `started_at`) VALUES
(1, 39727276, 7, '2023-02-18 23:42:57', 2, 63934637, '2023-02-18 23:42:02'),
(2, 63934637, 7, '2023-02-18 23:43:38', 4, 63934637, '2023-02-18 23:43:05'),
(3, 63934637, 7, '2023-02-18 23:44:49', 10, 63934637, '2023-02-18 23:43:44');

-- --------------------------------------------------------

--
-- Table structure for table `game_status`
--

CREATE TABLE `game_status` (
  `version` int(11) NOT NULL,
  `status` int(11) DEFAULT NULL,
  `starts_at` datetime NOT NULL DEFAULT current_timestamp(),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `game_status`
--

INSERT INTO `game_status` (`version`, `status`, `starts_at`, `created_at`) VALUES
(0, NULL, '2023-01-21 13:07:06', '2023-01-21 18:07:06'),
(1, NULL, '2023-01-21 13:13:26', '2023-01-21 18:13:26'),
(2, NULL, '2023-01-28 13:03:36', '2023-01-28 18:03:36'),
(3, NULL, '2023-01-31 13:01:20', '2023-01-31 18:01:20'),
(4, NULL, '2023-02-05 13:12:23', '2023-02-05 18:12:23'),
(5, NULL, '2023-02-11 12:02:54', '2023-02-11 17:02:54');

-- --------------------------------------------------------

--
-- Table structure for table `playmat`
--

CREATE TABLE `playmat` (
  `game_id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `mana` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `playmat`
--

INSERT INTO `playmat` (`game_id`, `player_id`, `mana`) VALUES
(1, 39727276, 6),
(1, 63934637, 6),
(2, 39727276, 4),
(2, 63934637, 3),
(3, 39727276, 0),
(3, 63934637, 0);

-- --------------------------------------------------------

--
-- Table structure for table `sound`
--

CREATE TABLE `sound` (
  `card_id` int(11) NOT NULL,
  `variant_id` int(11) NOT NULL DEFAULT 0,
  `zone_id` int(11) NOT NULL DEFAULT 2,
  `effect_name` varchar(24) NOT NULL,
  `sound_data` longblob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `turn_passer`
--

CREATE TABLE `turn_passer` (
  `game_id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `variant`
--

CREATE TABLE `variant` (
  `card_id` int(11) NOT NULL,
  `variant_id` int(11) NOT NULL DEFAULT 0,
  `variant_name` varchar(32) NOT NULL DEFAULT 'Default',
  `small_image` longblob NOT NULL,
  `big_image` longblob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `zone`
--

CREATE TABLE `zone` (
  `id` int(11) NOT NULL,
  `name` varchar(12) NOT NULL,
  `vacancy` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `zone`
--

INSERT INTO `zone` (`id`, `name`, `vacancy`) VALUES
(0, 'deck', -1),
(1, 'hand', 5),
(2, 'field', 6),
(3, 'grave', -1),
(4, 'non_grave', NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `attack`
--
ALTER TABLE `attack`
  ADD PRIMARY KEY (`game_id`,`player_id`,`attacker_id`,`target_id`),
  ADD KEY `attack_ibfk_3` (`attacker_id`),
  ADD KEY `target_id` (`target_id`),
  ADD KEY `attack_ibfk_2` (`player_id`);

--
-- Indexes for table `card`
--
ALTER TABLE `card`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `card_effect`
--
ALTER TABLE `card_effect`
  ADD PRIMARY KEY (`owner_id`,`trigger_condition`,`trigger_zone`,`effect`),
  ADD KEY `trigger_zone` (`trigger_zone`);

--
-- Indexes for table `card_instance`
--
ALTER TABLE `card_instance`
  ADD PRIMARY KEY (`instance_id`),
  ADD KEY `base_card` (`base_id`),
  ADD KEY `zone_id` (`zone_id`),
  ADD KEY `card_instance_ibfk_1` (`game_id`),
  ADD KEY `card_instance_ibfk_5` (`variant_id`),
  ADD KEY `card_instance_ibfk_2` (`player_id`);

--
-- Indexes for table `dev_card`
--
ALTER TABLE `dev_card`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `dev_card_effect`
--
ALTER TABLE `dev_card_effect`
  ADD PRIMARY KEY (`owner_id`,`trigger_condition`,`trigger_zone`,`effect`),
  ADD KEY `trigger_zone` (`trigger_zone`);

--
-- Indexes for table `game`
--
ALTER TABLE `game`
  ADD PRIMARY KEY (`id`),
  ADD KEY `game_ibfk_3` (`starting_player`);

--
-- Indexes for table `game_status`
--
ALTER TABLE `game_status`
  ADD PRIMARY KEY (`version`);

--
-- Indexes for table `playmat`
--
ALTER TABLE `playmat`
  ADD PRIMARY KEY (`game_id`,`player_id`),
  ADD KEY `player_id` (`player_id`);

--
-- Indexes for table `sound`
--
ALTER TABLE `sound`
  ADD PRIMARY KEY (`card_id`,`variant_id`,`zone_id`),
  ADD KEY `zone_id` (`zone_id`),
  ADD KEY `variant_id` (`variant_id`);

--
-- Indexes for table `turn_passer`
--
ALTER TABLE `turn_passer`
  ADD PRIMARY KEY (`game_id`,`player_id`),
  ADD KEY `turn_passer_ibfk_2` (`player_id`);

--
-- Indexes for table `variant`
--
ALTER TABLE `variant`
  ADD PRIMARY KEY (`card_id`,`variant_id`);

--
-- Indexes for table `zone`
--
ALTER TABLE `zone`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `attack`
--
ALTER TABLE `attack`
  ADD CONSTRAINT `attack_ibfk_1` FOREIGN KEY (`game_id`) REFERENCES `game` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `attack_ibfk_2` FOREIGN KEY (`player_id`) REFERENCES `playmat` (`player_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `attack_ibfk_3` FOREIGN KEY (`attacker_id`) REFERENCES `card_instance` (`instance_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `attack_ibfk_4` FOREIGN KEY (`target_id`) REFERENCES `card_instance` (`instance_id`) ON DELETE CASCADE;

--
-- Constraints for table `card_effect`
--
ALTER TABLE `card_effect`
  ADD CONSTRAINT `card_effect_ibfk_1` FOREIGN KEY (`owner_id`) REFERENCES `card` (`id`),
  ADD CONSTRAINT `card_effect_ibfk_2` FOREIGN KEY (`trigger_zone`) REFERENCES `zone` (`id`);

--
-- Constraints for table `card_instance`
--
ALTER TABLE `card_instance`
  ADD CONSTRAINT `card_instance_ibfk_1` FOREIGN KEY (`game_id`) REFERENCES `game` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `card_instance_ibfk_3` FOREIGN KEY (`base_id`) REFERENCES `card` (`id`),
  ADD CONSTRAINT `card_instance_ibfk_4` FOREIGN KEY (`zone_id`) REFERENCES `zone` (`id`);

--
-- Constraints for table `dev_card_effect`
--
ALTER TABLE `dev_card_effect`
  ADD CONSTRAINT `dev_card_effect_ibfk_1` FOREIGN KEY (`owner_id`) REFERENCES `dev_card` (`id`),
  ADD CONSTRAINT `dev_card_effect_ibfk_2` FOREIGN KEY (`trigger_zone`) REFERENCES `zone` (`id`);

--
-- Constraints for table `playmat`
--
ALTER TABLE `playmat`
  ADD CONSTRAINT `playmat_ibfk_1` FOREIGN KEY (`game_id`) REFERENCES `game` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `sound`
--
ALTER TABLE `sound`
  ADD CONSTRAINT `sound_ibfk_1` FOREIGN KEY (`card_id`) REFERENCES `card` (`id`),
  ADD CONSTRAINT `sound_ibfk_2` FOREIGN KEY (`zone_id`) REFERENCES `zone` (`id`);

--
-- Constraints for table `turn_passer`
--
ALTER TABLE `turn_passer`
  ADD CONSTRAINT `turn_passer_ibfk_1` FOREIGN KEY (`game_id`) REFERENCES `game` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `turn_passer_ibfk_2` FOREIGN KEY (`player_id`) REFERENCES `playmat` (`player_id`) ON DELETE CASCADE;

--
-- Constraints for table `variant`
--
ALTER TABLE `variant`
  ADD CONSTRAINT `variant_ibfk_1` FOREIGN KEY (`card_id`) REFERENCES `card` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
