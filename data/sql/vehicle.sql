-- phpMyAdmin SQL Dump
-- version 4.1.14
-- http://www.phpmyadmin.net
--
-- Client :  127.0.0.1
-- Généré le :  Ven 05 Février 2016 à 08:18
-- Version du serveur :  5.6.17
-- Version de PHP :  5.5.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de données :  `codata`
--

-- --------------------------------------------------------

--
-- Structure de la table `vehicle`
--

CREATE TABLE IF NOT EXISTS `vehicle` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `year` int(11) DEFAULT NULL,
  `brand` text,
  `model` text,
  `model_index` int(11) DEFAULT NULL,
  `drive_range` int(11) DEFAULT NULL,
  `fuel_cost` float DEFAULT NULL,
  `motor_power` float DEFAULT NULL,
  `amount_saved` float DEFAULT NULL,
  `charge_time` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=2247 ;

--
-- Contenu de la table `vehicle`
--

INSERT INTO `vehicle` (`id`, `year`, `brand`, `model`, `model_index`, `drive_range`, `fuel_cost`, `motor_power`, `amount_saved`, `charge_time`) VALUES
(2015, 2012, 'Tesla Motors', 'Model S', 1, 265, 700, 260, 9100, '12'),
(2018, 2012, 'NISSAN', 'LEAF', 901, 73, 600, 80, 9600, '7'),
(2024, 2012, 'CODA Automotive Inc', 'CODA', 1, 88, 850, 100, 8350, '6'),
(2027, 2012, 'Mitsubishi Motors Corporation', 'i-MiEV', 141, 62, 550, 49, 9850, '7'),
(2030, 2012, 'TOYOTA', 'RAV4 EV', 86, 103, 800, 115, 8600, '6'),
(2033, 2012, 'Azure Dynamics Incorporated', 'Transit Connect Electric Van/Wagon', 2, 56, 950, 52, 7850, '8'),
(2037, 2013, 'CODA Automotive Inc', 'CODA', 1, 88, 850, 100, 7350, '6'),
(2040, 2013, 'FIAT', '500e', 738, 87, 500, 82, 9100, '4'),
(2043, 2013, 'Ford Division', 'Focus FWD BEV', 242, 76, 600, 107, 8600, '4'),
(2046, 2013, 'Honda', 'FIT', 6, 82, 500, 92, 9100, '4'),
(2049, 2013, 'Mercedes-Benz', 'smart fortwo elec. drive (conv.)', 705, 68, 550, 55, 8850, '6'),
(2052, 2013, 'Mercedes-Benz', 'smart fortwo elec. drive (coupe)', 704, 68, 550, 55, 8850, '6'),
(2055, 2013, 'Mitsubishi Motors Corporation', 'i-MiEV', 141, 62, 550, 49, 8850, '7'),
(2058, 2013, 'NISSAN', 'LEAF', 901, 75, 550, 80, 8850, '4hrs (6.6kW 240V charger); 7hrs (3.6kW 240V charger)'),
(2061, 2013, 'Tesla Motors', 'Model S (85 kW-hr battery pack)', 1, 265, 700, 270, 8100, '12hrs (standard charger); 4.75hrs (with 80A dual charger option)'),
(2064, 2013, 'Tesla Motors', 'Model S (60 kW-hr battery pack)', 2, 208, 650, 225, 8350, '10hrs (standard charger); 3.75hrs (with 80A dual charger option)'),
(2067, 2013, 'Tesla Motors', 'Model S (40 kW-hr battery pack)', 3, 139, 650, 225, 8350, '6 hrs (standard charger); 2.5 hrs (with 80A dual charger option)'),
(2070, 2013, 'SCION', 'iQ EV', 21, 38, 500, 0, 9100, '4'),
(2073, 2013, 'TOYOTA', 'RAV4 EV', 93, 103, 800, 0, 7600, '6'),
(2077, 2014, 'BMW', 'I3 BEV', 100, 81, 500, 125, 9000, '4,0'),
(2080, 2014, 'BYD', 'e6', 1, 127, 950, 75, 6750, '6'),
(2084, 2014, 'Chevrolet', 'SPARK EV', 110, 82, 500, 104, 9000, '7'),
(2087, 2014, 'Fiat', '500e', 339, 87, 500, 82, 9000, '4'),
(2090, 2014, 'Ford', 'Focus Electric FWD', 422, 76, 600, 107, 8500, '3,6'),
(2092, 2014, 'Honda', 'FIT', 11, 82, 500, 92, 9000, '4'),
(2095, 2014, 'Mercedes-Benz', 'B-Class Electric Drive', 504, 87, 700, 132, 8000, '3,5'),
(2099, 2014, 'Mercedes-Benz', 'Smart fortwo elec. drive (conv.)', 705, 68, 550, 55, 8750, '6'),
(2102, 2014, 'Mercedes-Benz', 'Smart fortwo elec. drive (coupe)', 704, 68, 550, 55, 8750, '6'),
(2105, 2014, 'Mitsubishi Motors Corporation', 'i-MiEV', 141, 62, 550, 49, 8750, '7'),
(2108, 2014, 'NISSAN', 'LEAF', 901, 84, 550, 80, 8750, '5 hrs (6.6kW 240V charger); 8 hrs (3.6kW 240V charger)'),
(2111, 2014, 'Tesla Motors', 'Model S (85 kW-hr battery pack)', 1, 265, 700, 270, 8000, '12 hrs (standard charger); 4.75 hrs (with 80A dual charger option)'),
(2114, 2014, 'Tesla Motors', 'Model S (60 kW-hr battery pack)', 2, 208, 650, 225, 8250, '10 hrs (standard charger); 3.75 hrs (with 80A dual charger option)'),
(2117, 2014, 'Tesla Motors', 'Model S AWD (85 kW-hr battery pack)', 4, 242, 700, 180, 8000, '12 hrs (standard charger); 4.75 hrs (with 80A dual charger option)'),
(2119, 2014, 'TOYOTA', 'RAV4 EV', 204, 103, 800, 0, 7500, '6'),
(2123, 2015, 'BMW', 'I3 BEV', 100, 81, 500, 125, 8500, '4'),
(2126, 2015, 'BYD', 'e6', 1, 127, 950, 75, 6250, '6'),
(2130, 2015, 'Chevrolet', 'SPARK EV', 55, 82, 500, 104, 8500, '7,0'),
(2133, 2015, 'FIAT', '500e', 38, 87, 500, 82, 8500, '4,0'),
(2136, 2015, 'Ford', 'Focus Electric FWD', 116, 76, 600, 107, 8000, '3,6'),
(2138, 2015, 'Kia', 'Soul Electric', 34, 93, 600, 81, 8000, '4,0'),
(2141, 2015, 'Mercedes-Benz', 'B-Class Electric Drive', 504, 87, 700, 132, 7500, '3,5'),
(2145, 2015, 'Mercedes-Benz', 'Smart fortwo elec. drive (conv.)', 705, 68, 550, 55, 8250, '6,0'),
(2148, 2015, 'Mercedes-Benz', 'Smart fortwo elec. drive (coupe)', 704, 68, 550, 55, 8250, '6,0'),
(2151, 2015, 'NISSAN', 'LEAF', 901, 84, 550, 80, 8250, '5 hrs (6.6kW 240V charger); 8 hrs (3.6kW 240V charger)'),
(2154, 2015, 'Tesla Motors', 'Model S (60 kW-hr battery pack)', 2, 208, 650, 225, 7750, '10 hrs (standard charger); 3.75 hrs (with 80A dual charger option)'),
(2157, 2015, 'Tesla Motors', 'Model S (85 kW-hr battery pack)', 1, 265, 700, 270, 7500, '12 hrs (standard charger); 4.75 hrs (with 80A dual charger option)'),
(2160, 2015, 'Tesla Motors', 'Model S (90 kW-hr battery pack)', 71, 265, 700, 285, 7500, '12 hrs (standard charger); 4.75 hrs (with 80A dual charger option)'),
(2163, 2015, 'Tesla Motors', 'Model S AWD - 70D', 6, 240, 600, 140, 8000, '12 hrs (standard charger); 4.75 hrs (with 80A dual charger option)'),
(2166, 2015, 'Tesla Motors', 'Model S AWD - 85D', 5, 270, 600, 140, 8000, '12 hrs (standard charger); 4.75 hrs (with 80A dual charger option)'),
(2169, 2015, 'Tesla Motors', 'Model S AWD - 90D', 7, 270, 600, 140, 8000, '12 hrs (standard charger); 4.75 hrs (with 80A dual charger option)'),
(2172, 2015, 'Tesla Motors', 'Model S AWD - P85D', 4, 253, 650, 164, 7750, '12 hrs (standard charger); 4.75 hrs (with 80A dual charger option)'),
(2175, 2015, 'Tesla Motors', 'Model S AWD - P90D', 8, 253, 650, 164, 7750, '12 hrs (standard charger); 4.75 hrs (with 80A dual charger option)'),
(2177, 2015, 'Volkswagen', 'e-Golf', 109, 83, 550, 85, 8250, '4,0'),
(2182, 2016, 'BMW', 'I3 BEV', 100, 81, 550, 125, 6250, '4'),
(2186, 2016, 'Chevrolet', 'SPARK EV', 146, 82, 550, 105, 6250, '7'),
(2189, 2016, 'FIAT', '500e', 3, 84, 600, 82, 6000, '4'),
(2192, 2016, 'Ford', 'Focus Electric FWD', 57, 76, 600, 107, 6000, '3,6'),
(2195, 2016, 'KIA MOTORS CORPORATION', 'Soul Electric', 37, 93, 600, 81, 6000, '4'),
(2197, 2016, 'Mercedes-Benz', 'B250e', 504, 87, 800, 132, 5000, '3,5'),
(2201, 2016, 'Mercedes-Benz', 'smart fortwo elec. drive (conv.)', 705, 68, 600, 55, 6000, '6'),
(2204, 2016, 'Mercedes-Benz', 'smart fortwo elec. drive (coupe)', 704, 68, 600, 55, 6000, '6'),
(2207, 2016, 'Mitsubishi Motors Corporation', 'i-MiEV', 141, 62, 600, 49, 6000, '7,0'),
(2209, 2016, 'NISSAN', 'LEAF  (24 kW-hr battery pack)', 901, 84, 600, 80, 6000, '5 hrs (6.6kW 240V charger); 8 hrs (3.6kW 240V charger)'),
(2212, 2016, 'NISSAN', 'LEAF (30 kW-hr battery pack)', 902, 107, 600, 80, 6000, '6 (6.6kW 240V charger)'),
(2216, 2016, 'Tesla Motors', 'Model S (70 kW-hr battery pack)', 3, 234, 750, 285, 5250, '10 hrs (standard charger); 3.75 hrs (with 80A dual charger option)'),
(2219, 2016, 'Tesla Motors', 'Model S (85 kW-hr battery pack)', 1, 265, 750, 285, 5250, '12 hrs (standard charger); 4.75 hrs (with 80A dual charger option)'),
(2222, 2016, 'Tesla Motors', 'Model S (90 kW-hr battery pack)', 71, 265, 750, 285, 5250, '12 hrs (standard charger); 4.75 hrs (with 80A dual charger option)'),
(2225, 2016, 'Tesla Motors', 'Model S AWD - 70D', 6, 240, 650, 193, 5750, '12 hrs (standard charger); 4.75 hrs (with 80A dual charger option)'),
(2228, 2016, 'Tesla Motors', 'Model S AWD - 85D', 5, 270, 650, 193, 5750, '12 hrs (standard charger); 4.75 hrs (with 80A dual charger option)'),
(2231, 2016, 'Tesla Motors', 'Model S AWD - 90D', 7, 270, 650, 193, 5750, '12 hrs (standard charger); 4.75 hrs (with 80A dual charger option)'),
(2234, 2016, 'Tesla Motors', 'Model S AWD - P85D', 4, 253, 700, 193, 5500, '12 hrs (standard charger); 4.75 hrs (with 80A dual charger option)'),
(2237, 2016, 'Tesla Motors', 'Model S AWD - P90D', 8, 253, 700, 193, 5500, '12 hrs (standard charger); 4.75 hrs (with 80A dual charger option)'),
(2240, 2016, 'Tesla Motors', 'Model X AWD - 90D', 9, 257, 700, 193, 5500, '12 hrs (standard charger); 4.75 hrs (with 80A dual charger option)'),
(2243, 2016, 'Tesla Motors', 'Model X AWD - P90D', 10, 250, 750, 193, 5250, '12 hrs (standard charger); 4.75 hrs (with 80A dual charger option)'),
(2245, 2016, 'Volkswagen', 'e-Golf', 86, 83, 550, 85, 6250, '7.0 hrs (3.6 kW charger); 3.7 hrs (7.2 kW charger)');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
