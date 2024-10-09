-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 13 Des 2023 pada 11.27
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `jatimparktikecting`
--

DELIMITER $$
--
-- Prosedur
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `doPembayaran` (IN `ID_Bayar` CHAR(10), IN `ID_Transaksi` CHAR(10))   BEGIN
	INSERT INTO pembayaran
    VALUES (ID_Bayar, 
            (SELECT DISTINCT(T.opDOB) FROM transaksi T WHERE T.transaksiID = ID_Transaksi), 
            'Online', 
            (SELECT SUM(T.harga) FROM transaksi T WHERE T.transaksiID = ID_Transaksi GROUP BY T.transaksiID), 
            ID_Transaksi);
     
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `doTiket` (IN `ID_Tiket` CHAR(10), IN `ID_Pembayaran` CHAR(10), IN `ID_Transaksi` CHAR(10), IN `ID_Pengunjung` CHAR(10), IN `ID_Paket` CHAR(5))   BEGIN 	

INSERT INTO tiket VALUES
(ID_Tiket, 1, 1, ID_Pembayaran, ID_Transaksi, ID_Pengunjung , ID_Paket);          

UPDATE tiket Ti     
SET Ti.tiketHarga = (SELECT T.harga                          
                     FROM transaksi T                          
                     WHERE T.paketID = ID_Paket AND T.transaksiID = ID_Transaksi),
    Ti.tiketJumlah = (SELECT T.jumlahPaket                          
                      FROM transaksi T                         
                      WHERE T.paketID = ID_Paket AND T.transaksiID = ID_Transaksi)
WHERE Ti.paketID = ID_Paket AND Ti.transaksiID = ID_Transaksi;
                      
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `doTransaksi` (IN `ID_Transaksi` CHAR(10), IN `ID_Pengunjung` CHAR(10), IN `ID_Staff` CHAR(5), IN `ID_Paket` CHAR(5), IN `opDate` CHAR(10), IN `jumlah_paket` INT)   BEGIN 
    -- Memasukkan data ke dalam tabel transaksi
    INSERT INTO transaksi
    VALUES (ID_Transaksi, 1, jumlah_paket, ID_Pengunjung, ID_Staff, ID_Paket, opDate);

    -- Menghitung total harga dari transaksi dan memperbarui kolom harga pada tabel transaksi
    UPDATE transaksi T
    SET T.harga = (
        SELECT ((P.paketHargaNormal + O.tambahanHarga) * jumlah_paket) 
        FROM operasional O
        JOIN paket P ON T.paketID = P.paketID 
        WHERE O.opDOB = opDate AND P.paketID = ID_Paket
    )
    WHERE T.transaksiID = ID_Transaksi AND T.paketID = ID_Paket;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `alamatpengunjung`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `alamatpengunjung` (
`id` mediumtext
,`nama` mediumtext
,`kota` varchar(50)
,`jumlah` bigint(21)
);

-- --------------------------------------------------------

--
-- Struktur dari tabel `category`
--

CREATE TABLE `category` (
  `categoryID` char(5) NOT NULL,
  `namaCategory` varchar(25) NOT NULL
) ;

--
-- Dumping data untuk tabel `category`
--

INSERT INTO `category` (`categoryID`, `namaCategory`) VALUES
('CA001', 'Adventure'),
('CA002', 'Thrill'),
('CA003', 'Edukasi'),
('CA004', 'Anak-Anak'),
('CA005', 'Rileksasi'),
('CA006', 'Petualangan Air'),
('CA007', 'Keluarga Besar'),
('CA008', 'Komedi'),
('CA009', 'Family'),
('CA010', 'Fantasi'),
('CA011', 'Seni dan Budaya');

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `listpenjualanpaket`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `listpenjualanpaket` (
`ID_Paket` char(5)
,`Nama_Paket` varchar(30)
,`Jumlah_Paket` decimal(32,0)
,`Total_Harga` decimal(32,0)
);

-- --------------------------------------------------------

--
-- Stand-in struktur untuk tampilan `listwahanasesuaipaket`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `listwahanasesuaipaket` (
`ID_Paket` char(5)
,`Nama_Paket` varchar(30)
,`Nama_Kategori` mediumtext
,`List_Wahana` mediumtext
,`Lokasi_Wahana` mediumtext
);

-- --------------------------------------------------------

--
-- Struktur dari tabel `operasional`
--

CREATE TABLE `operasional` (
  `opDOB` char(10) NOT NULL,
  `jamBuka` char(5) NOT NULL,
  `jamTutup` char(5) NOT NULL,
  `hari` varchar(10) NOT NULL,
  `tambahanHarga` int(11) NOT NULL
) ;

--
-- Dumping data untuk tabel `operasional`
--

INSERT INTO `operasional` (`opDOB`, `jamBuka`, `jamTutup`, `hari`, `tambahanHarga`) VALUES
('2023-12-02', '08:30', '16:30', 'Sabtu', 20000),
('2023-12-03', '08:30', '16:30', 'Minggu', 20000),
('2023-12-04', '08:30', '16:30', 'Senin', 0),
('2023-12-05', '08:30', '16:30', 'Selasa', 0),
('2023-12-06', '08:30', '16:30', 'Rabu', 0),
('2023-12-07', '08:30', '16:30', 'Kamis', 0),
('2023-12-08', '08:30', '16:30', 'Jumat', 20000),
('2023-12-09', '08:30', '16:30', 'Sabtu', 20000),
('2023-12-10', '08:30', '16:30', 'Minggu', 20000),
('2023-12-11', '08:30', '16:30', 'Senin', 0),
('2023-12-12', '08:30', '16:30', 'Selasa', 0),
('2023-12-13', '08:30', '16:30', 'Rabu', 0),
('2023-12-14', '08:30', '16:30', 'Kamis', 0),
('2023-12-15', '08:30', '16:30', 'Jumat', 20000),
('2023-12-16', '08:30', '16:30', 'Sabtu', 20000),
('2023-12-17', '08:30', '16:30', 'Minggu', 20000),
('2023-12-18', '08:30', '16:30', 'Senin', 40000),
('2023-12-19', '08:30', '16:30', 'Selasa', 40000),
('2023-12-20', '08:30', '16:30', 'Rabu', 40000),
('2023-12-21', '08:30', '16:30', 'Kamis', 40000),
('2023-12-22', '08:30', '16:30', 'Jumat', 40000),
('2023-12-23', '08:30', '16:30', 'Sabtu', 40000),
('2023-12-24', '08:30', '16:30', 'Minggu', 40000),
('2023-12-25', '08:30', '16:30', 'Senin', 40000),
('2023-12-26', '08:30', '16:30', 'Selasa', 40000),
('2023-12-27', '08:30', '16:30', 'Rabu', 40000),
('2023-12-28', '08:30', '16:30', 'Kamis', 40000),
('2023-12-29', '08:30', '16:30', 'Jumat', 40000),
('2023-12-30', '08:30', '16:30', 'Sabtu', 40000),
('2023-12-31', '08:30', '16:30', 'Minggu', 40000);

-- --------------------------------------------------------

--
-- Struktur dari tabel `paket`
--

CREATE TABLE `paket` (
  `paketID` char(5) NOT NULL,
  `paketNama` varchar(30) NOT NULL,
  `paketHargaNormal` int(11) NOT NULL
) ;

--
-- Dumping data untuk tabel `paket`
--

INSERT INTO `paket` (`paketID`, `paketNama`, `paketHargaNormal`) VALUES
('PA001', 'Family Package', 60000),
('PA002', 'Adventure Package', 80000),
('PA003', 'Weekend Package', 90000),
('PA004', 'VIP Package', 120000),
('PA005', 'Thrill Seeker Package', 95000),
('PA006', 'Kids Special', 55000),
('PA007', 'Couples Retreat', 110000),
('PA008', 'Group Fun', 70000),
('PA009', 'Holiday Splendor', 100000),
('PA010', 'Basic Package', 50000),
('PA011', 'Premium Package', 75000);

-- --------------------------------------------------------

--
-- Struktur dari tabel `pembayaran`
--

CREATE TABLE `pembayaran` (
  `paymentID` char(10) NOT NULL,
  `paymentDate` date NOT NULL,
  `paymentMethod` varchar(10) NOT NULL,
  `paymentTotal` int(11) NOT NULL,
  `transaksiID` char(10) NOT NULL
) ;

--
-- Dumping data untuk tabel `pembayaran`
--

INSERT INTO `pembayaran` (`paymentID`, `paymentDate`, `paymentMethod`, `paymentTotal`, `transaksiID`) VALUES
('ABC1234567', '2023-12-03', 'Online', 1500000, '1111222233'),
('BCD0123456', '2023-12-15', 'Online', 800000, '1010111112'),
('CDE1234567', '2023-12-16', 'Online', 400000, '1111121213'),
('DEF2345678', '2023-12-05', 'Online', 600000, '2222333344'),
('GHI3456782', '2023-12-05', 'Online', 1200000, '3333444455'),
('JKL4567890', '2023-12-08', 'Online', 680000, '4444555566'),
('MNO5678901', '2023-12-08', 'Online', 875000, '5555666677'),
('PGR6789012', '2023-12-11', 'Online', 940000, '6666777788'),
('STU7890123', '2023-12-12', 'Online', 240000, '7777888899'),
('VWX8901234', '2023-12-13', 'Online', 720000, '8888999910'),
('YZA9012345', '2023-12-14', 'Online', 880000, '9999101011');

-- --------------------------------------------------------

--
-- Struktur dari tabel `pengunjung`
--

CREATE TABLE `pengunjung` (
  `pengunjungID` char(10) NOT NULL,
  `namaPengunjung` varchar(50) NOT NULL,
  `jenisKelamin` char(1) NOT NULL,
  `alamat` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `pengunjungDOB` date DEFAULT NULL
) ;

--
-- Dumping data untuk tabel `pengunjung`
--

INSERT INTO `pengunjung` (`pengunjungID`, `namaPengunjung`, `jenisKelamin`, `alamat`, `email`, `pengunjungDOB`) VALUES
('1000000001', 'Nabila', 'P', 'Kediri', 'nabila227@gmail.com', '2004-01-08'),
('1000000002', 'Sekar', 'P', 'Magelang', 'sekar123@gmail.com', '2002-09-09'),
('1000000003', 'Rahel', 'P', 'Pasuruan', 'rahelo@yahoo.com', '2001-06-10'),
('1000000004', 'Regina', 'P', 'Samarinda', 'regin4@gmail.com', '2004-09-11'),
('1000000005', 'Levi', 'P', 'Singosari', 'levi@gmail.com', '2007-01-12'),
('1000000006', 'Jovan', 'L', 'Surabaya', 'navoj007@yahoo.com', '2004-01-13'),
('1000000007', 'Jenar', 'L', 'Malang', 'jenara441@gmail.com', '2004-01-14'),
('1000000008', 'Laras', 'P', 'Banyuwangi', 'larasatiAyu@gmail.com', '2004-01-15'),
('1000000009', 'Patricia', 'P', 'Yogyakarta', 'patriciii@gmail.com', '2004-01-16'),
('1000000010', 'Jared', 'L', 'Solo', 'jared79@yahoo.com', '2004-01-17'),
('1000000011', 'Narendra', 'L', 'Bali', 'nareansa@gmail.com', '2004-01-18'),
('1000000012', 'Zhafira', 'P', 'Lombok', 'zhafiramaa@gmail.com', '2004-01-19'),
('1000000013', 'Jamal', 'L', 'Sidoarjo', 'jalaman@yahoo.com', '2004-01-20'),
('1000000014', 'Haikal', 'L', 'Bandung', 'haehaikal@gmail.com', '2004-01-21'),
('1000000015', 'Arabella', 'P', 'Jakarta', 'bellaswan@yahoo.com', '2004-01-22'),
('1000000016', 'James Arie', 'P', 'Kediri', 'jamesarie@gmail.com', '2004-01-08'),
('1000000017', 'Arland Manov', 'P', 'Magelang', 'arlanm@gmail.com', '2002-09-09'),
('1000000018', 'Ryani Dubois', 'P', 'Magelang', 'ryadibuo@yahoo.com', '2001-06-10'),
('1000000019', 'Regina Marlie', 'P', 'Samarinda', 'reginaa@gmail.com', '2004-09-11'),
('1000000020', 'Lendrawan', 'P', 'Singosari', 'lendraw@gmail.com', '2007-01-12'),
('1000000021', 'Cella', 'L', 'Surabaya', 'cellaaa@yahoo.com', '2004-01-13'),
('1000000022', 'Cernala Ayu', 'L', 'Malang', 'cerayu@gmail.com', '2004-01-14'),
('1000000023', 'Larasati Ayudya', 'P', 'Banyuwangi', 'laraayu@gmail.com', '2004-01-15'),
('1000000024', 'Jenna Mentega', 'P', 'Yogyakarta', 'jenaaa@gmail.com', '2004-01-16'),
('1000000025', 'Veinna', 'L', 'Solo', 'vevee@yahoo.com', '2004-01-17'),
('1000000026', 'Lulu', 'L', 'Bali', 'lul@gmail.com', '2004-01-18'),
('1000000027', 'Vino', 'P', 'Lombok', 'vino@gmail.com', '2004-01-19'),
('1000000028', 'Thedore Matt', 'L', 'Sidoarjo', 'Theodore@yahoo.com', '2004-01-20'),
('1000000029', 'Haikal Hasibuan', 'L', 'Bandung', 'haehaikal@gmail.com', '2004-01-21'),
('1000000030', 'Xaverius Gale', 'P', 'Jakarta', 'Xaver@yahoo.com', '2004-01-22'),
('1000000031', 'Evanie Gale', 'P', 'Magelang', 'Evanie@yahoo.com', '2004-01-22'),
('1000000032', 'Naraya Drisca', 'P', 'Magelang', 'naraya@yahoo.com', '2004-01-22'),
('1000000033', 'Bunga', 'P', 'Magelang', 'ngabu@gmail.com', '2004-01-08');

-- --------------------------------------------------------

--
-- Struktur dari tabel `staff`
--

CREATE TABLE `staff` (
  `staffID` char(5) NOT NULL,
  `staffNama` varchar(50) NOT NULL,
  `staffJob` varchar(30) NOT NULL,
  `salary` int(11) NOT NULL
) ;

--
-- Dumping data untuk tabel `staff`
--

INSERT INTO `staff` (`staffID`, `staffNama`, `staffJob`, `salary`) VALUES
('ST001', 'Jamie', 'Kasir', 12000),
('ST002', 'Landon', 'Kebersihan', 25000),
('ST003', 'Lia', 'Keamanan', 40000),
('ST004', 'Rara', 'Teknisi', 50000),
('ST005', 'Ruben', 'Badut', 37000),
('ST006', 'Alam', 'Petugas Parkir', 30000),
('ST007', 'Bambang', 'Customer Service', 37000),
('ST008', 'Gibran', 'Kebersihan', 30000),
('ST009', 'Rama', 'Keamanan', 38000),
('ST010', 'Fiona', 'Kasir', 18000),
('ST011', 'Jati', 'Operator Wahana', 37000),
('ST012', 'Devina', 'Operator Wahana', 39000),
('ST013', 'Dylan', 'Operator Wahana', 36000),
('ST014', 'Suma', 'Teknisi ', 45000),
('ST015', 'Mira', 'Pertolongan Pertama', 32000);

-- --------------------------------------------------------

--
-- Struktur dari tabel `tiket`
--

CREATE TABLE `tiket` (
  `tiketID` char(10) NOT NULL,
  `tiketHarga` int(11) NOT NULL,
  `tiketJumlah` int(11) NOT NULL,
  `paymentID` char(10) NOT NULL,
  `transaksiID` char(10) NOT NULL,
  `pengunjungID` char(10) NOT NULL,
  `paketID` char(5) NOT NULL
) ;

--
-- Dumping data untuk tabel `tiket`
--

INSERT INTO `tiket` (`tiketID`, `tiketHarga`, `tiketJumlah`, `paymentID`, `transaksiID`, `pengunjungID`, `paketID`) VALUES
('1011121314', 800000, 10, 'BCD0123456', '1010111112', '1000000010', 'PA001'),
('1112131415', 400000, 5, 'CDE1234567', '1111121213', '1000000011', 'PA001'),
('1234567890', 800000, 8, 'ABC1234567', '1111222233', '1000000001', 'PA002'),
('1234567890', 520000, 4, 'ABC1234567', '1111222233', '1000000001', 'PA007'),
('1234567890', 180000, 2, 'ABC1234567', '1111222233', '1000000001', 'PA008'),
('2345678910', 600000, 10, 'DEF2345678', '2222333344', '1000000002', 'PA001'),
('3456789101', 600000, 10, 'GHI3456782', '3333444455', '1000000003', 'PA001'),
('3456789101', 600000, 5, 'GHI3456782', '3333444455', '1000000003', 'PA004'),
('4567891011', 320000, 4, 'JKL4567890', '4444555566', '1000000004', 'PA001'),
('4567891011', 360000, 3, 'JKL4567890', '4444555566', '1000000004', 'PA009'),
('5678910111', 500000, 5, 'MNO5678901', '5555666677', '1000000005', 'PA002'),
('5678910111', 375000, 5, 'MNO5678901', '5555666677', '1000000005', 'PA006'),
('6789101112', 560000, 7, 'PGR6789012', '6666777788', '1000000006', 'PA002'),
('6789101112', 380000, 4, 'PGR6789012', '6666777788', '1000000006', 'PA005'),
('7891011121', 240000, 4, 'STU7890123', '7777888899', '1000000007', 'PA001'),
('8910111213', 720000, 9, 'VWX8901234', '8888999910', '1000000008', 'PA002'),
('9101112131', 880000, 8, 'YZA9012345', '9999101011', '1000000009', 'PA007');

-- --------------------------------------------------------

--
-- Struktur dari tabel `transaksi`
--

CREATE TABLE `transaksi` (
  `transaksiID` char(10) NOT NULL,
  `harga` int(11) NOT NULL,
  `jumlahPaket` int(11) NOT NULL,
  `pengunjungID` char(10) NOT NULL,
  `staffID` char(5) NOT NULL,
  `paketID` char(5) NOT NULL,
  `opDOB` char(10) NOT NULL
) ;

--
-- Dumping data untuk tabel `transaksi`
--

INSERT INTO `transaksi` (`transaksiID`, `harga`, `jumlahPaket`, `pengunjungID`, `staffID`, `paketID`, `opDOB`) VALUES
('1010111112', 800000, 10, '1000000010', 'ST010', 'PA001', '2023-12-15'),
('1111121213', 400000, 5, '1000000011', 'ST001', 'PA001', '2023-12-16'),
('1111222233', 800000, 8, '1000000001', 'ST001', 'PA002', '2023-12-03'),
('1111222233', 520000, 4, '1000000001', 'ST001', 'PA007', '2023-12-03'),
('1111222233', 180000, 2, '1000000001', 'ST001', 'PA008', '2023-12-03'),
('2222333344', 600000, 10, '1000000002', 'ST010', 'PA001', '2023-12-05'),
('3333444455', 600000, 10, '1000000003', 'ST001', 'PA001', '2023-12-05'),
('3333444455', 600000, 5, '1000000003', 'ST001', 'PA004', '2023-12-05'),
('4444555566', 320000, 4, '1000000004', 'ST010', 'PA001', '2023-12-08'),
('4444555566', 360000, 3, '1000000004', 'ST010', 'PA009', '2023-12-08'),
('5555666677', 500000, 5, '1000000005', 'ST001', 'PA002', '2023-12-08'),
('5555666677', 375000, 5, '1000000005', 'ST001', 'PA006', '2023-12-08'),
('6666777788', 560000, 7, '1000000006', 'ST010', 'PA002', '2023-12-11'),
('6666777788', 380000, 4, '1000000006', 'ST010', 'PA005', '2023-12-11'),
('7777888899', 240000, 4, '1000000007', 'ST001', 'PA001', '2023-12-12'),
('8888999910', 720000, 9, '1000000008', 'ST010', 'PA002', '2023-12-13'),
('9999101011', 880000, 8, '1000000009', 'ST001', 'PA007', '2023-12-14');

-- --------------------------------------------------------

--
-- Struktur dari tabel `wahana`
--

CREATE TABLE `wahana` (
  `wahanaID` char(5) NOT NULL,
  `wahanaNama` varchar(50) NOT NULL,
  `wahanaLokasi` varchar(10) NOT NULL,
  `paketID` char(5) NOT NULL,
  `categoryID` char(5) NOT NULL,
  `staffID` char(5) NOT NULL
) ;

--
-- Dumping data untuk tabel `wahana`
--

INSERT INTO `wahana` (`wahanaID`, `wahanaNama`, `wahanaLokasi`, `paketID`, `categoryID`, `staffID`) VALUES
('WA001', 'Roller Coaster', 'Zone C', 'PA001', 'CA001', 'ST013'),
('WA002', 'Bianglala', 'Zone D', 'PA002', 'CA009', 'ST011'),
('WA003', 'Flying Swings', 'Zone E', 'PA001', 'CA001', 'ST011'),
('WA004', 'Labirin', 'Zone F', 'PA002', 'CA001', 'ST012'),
('WA005', 'Kastil Fantasi', 'Zone G', 'PA001', 'CA004', 'ST013'),
('WA006', 'Taman Bermain', 'Zone H', 'PA002', 'CA005', 'ST011'),
('WA007', 'Taman Santai', 'Zone I', 'PA002', 'CA009', 'ST012'),
('WA008', 'Petualangan Air', 'Zone J', 'PA001', 'CA006', 'ST013'),
('WA009', 'Panggung Hiburan', 'Zone K', 'PA007', 'CA009', 'ST011'),
('WA010', 'Perjalanan Perahu', 'Zone L', 'PA007', 'CA006', 'ST012'),
('WA011', 'Becak Air', 'Zone L', 'PA007', 'CA006', 'ST012');

-- --------------------------------------------------------

--
-- Struktur untuk view `alamatpengunjung`
--
DROP TABLE IF EXISTS `alamatpengunjung`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `alamatpengunjung`  AS SELECT group_concat(`p`.`pengunjungID` separator '\n') AS `id`, group_concat(`p`.`namaPengunjung` separator '\n') AS `nama`, `p`.`alamat` AS `kota`, count(`p`.`alamat`) AS `jumlah` FROM `pengunjung` AS `p` GROUP BY `p`.`alamat` ORDER BY count(`p`.`alamat`) DESC, `p`.`alamat` ASC ;

-- --------------------------------------------------------

--
-- Struktur untuk view `listpenjualanpaket`
--
DROP TABLE IF EXISTS `listpenjualanpaket`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `listpenjualanpaket`  AS SELECT `p`.`paketID` AS `ID_Paket`, `p`.`paketNama` AS `Nama_Paket`, sum(`t`.`jumlahPaket`) AS `Jumlah_Paket`, sum(`t`.`harga`) AS `Total_Harga` FROM (`paket` `p` join `transaksi` `t` on(`p`.`paketID` = `t`.`paketID`)) GROUP BY `p`.`paketID`, `p`.`paketNama` ORDER BY sum(`t`.`jumlahPaket`) DESC ;

-- --------------------------------------------------------

--
-- Struktur untuk view `listwahanasesuaipaket`
--
DROP TABLE IF EXISTS `listwahanasesuaipaket`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `listwahanasesuaipaket`  AS SELECT `p`.`paketID` AS `ID_Paket`, `p`.`paketNama` AS `Nama_Paket`, group_concat(`c`.`namaCategory` separator '\n') AS `Nama_Kategori`, group_concat(`w`.`wahanaNama` separator '\n') AS `List_Wahana`, group_concat(`w`.`wahanaLokasi` separator '\n') AS `Lokasi_Wahana` FROM ((`paket` `p` join `wahana` `w` on(`w`.`paketID` = `p`.`paketID`)) join `category` `c` on(`w`.`categoryID` = `c`.`categoryID`)) GROUP BY `p`.`paketID` ;

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`categoryID`);

--
-- Indeks untuk tabel `operasional`
--
ALTER TABLE `operasional`
  ADD PRIMARY KEY (`opDOB`);

--
-- Indeks untuk tabel `paket`
--
ALTER TABLE `paket`
  ADD PRIMARY KEY (`paketID`);

--
-- Indeks untuk tabel `pembayaran`
--
ALTER TABLE `pembayaran`
  ADD PRIMARY KEY (`paymentID`),
  ADD KEY `transaksiID` (`transaksiID`);

--
-- Indeks untuk tabel `pengunjung`
--
ALTER TABLE `pengunjung`
  ADD PRIMARY KEY (`pengunjungID`);

--
-- Indeks untuk tabel `staff`
--
ALTER TABLE `staff`
  ADD PRIMARY KEY (`staffID`);

--
-- Indeks untuk tabel `tiket`
--
ALTER TABLE `tiket`
  ADD PRIMARY KEY (`tiketID`,`paketID`),
  ADD KEY `paymentID` (`paymentID`),
  ADD KEY `transaksiID` (`transaksiID`),
  ADD KEY `pengunjungID` (`pengunjungID`),
  ADD KEY `paketID` (`paketID`);

--
-- Indeks untuk tabel `transaksi`
--
ALTER TABLE `transaksi`
  ADD PRIMARY KEY (`transaksiID`,`paketID`),
  ADD KEY `pengunjungID` (`pengunjungID`),
  ADD KEY `staffID` (`staffID`),
  ADD KEY `paketID` (`paketID`),
  ADD KEY `opDOB` (`opDOB`);

--
-- Indeks untuk tabel `wahana`
--
ALTER TABLE `wahana`
  ADD PRIMARY KEY (`wahanaID`),
  ADD KEY `paketID` (`paketID`),
  ADD KEY `categoryID` (`categoryID`),
  ADD KEY `staffID` (`staffID`);

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `pembayaran`
--
ALTER TABLE `pembayaran`
  ADD CONSTRAINT `pembayaran_ibfk_1` FOREIGN KEY (`transaksiID`) REFERENCES `transaksi` (`transaksiID`);

--
-- Ketidakleluasaan untuk tabel `tiket`
--
ALTER TABLE `tiket`
  ADD CONSTRAINT `tiket_ibfk_1` FOREIGN KEY (`paymentID`) REFERENCES `pembayaran` (`paymentID`),
  ADD CONSTRAINT `tiket_ibfk_2` FOREIGN KEY (`transaksiID`) REFERENCES `transaksi` (`transaksiID`),
  ADD CONSTRAINT `tiket_ibfk_3` FOREIGN KEY (`pengunjungID`) REFERENCES `pengunjung` (`pengunjungID`),
  ADD CONSTRAINT `tiket_ibfk_4` FOREIGN KEY (`paketID`) REFERENCES `paket` (`paketID`);

--
-- Ketidakleluasaan untuk tabel `transaksi`
--
ALTER TABLE `transaksi`
  ADD CONSTRAINT `transaksi_ibfk_1` FOREIGN KEY (`pengunjungID`) REFERENCES `pengunjung` (`pengunjungID`),
  ADD CONSTRAINT `transaksi_ibfk_2` FOREIGN KEY (`staffID`) REFERENCES `staff` (`staffID`),
  ADD CONSTRAINT `transaksi_ibfk_3` FOREIGN KEY (`paketID`) REFERENCES `paket` (`paketID`),
  ADD CONSTRAINT `transaksi_ibfk_4` FOREIGN KEY (`opDOB`) REFERENCES `operasional` (`opDOB`);

--
-- Ketidakleluasaan untuk tabel `wahana`
--
ALTER TABLE `wahana`
  ADD CONSTRAINT `wahana_ibfk_1` FOREIGN KEY (`paketID`) REFERENCES `paket` (`paketID`),
  ADD CONSTRAINT `wahana_ibfk_2` FOREIGN KEY (`categoryID`) REFERENCES `category` (`categoryID`),
  ADD CONSTRAINT `wahana_ibfk_3` FOREIGN KEY (`staffID`) REFERENCES `staff` (`staffID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
