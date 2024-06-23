
# scraping_mds

<p align="center">
  <img width="715" height="350" src="sinta_logo.png">
</p>

<div align="center">


# Scraping Website SINTA ID
[![scrap](https://github.com/yunnamentari/scraping_mds/actions/workflows/main.yml/badge.svg)](https://github.com/yunnamentari/scraping_mds/actions/workflows/main.yml)

</div>

## :bookmark_tabs: Menu
- [About](#pushpin-About)
- [Project Description](#clipboard-Project-Description)
- [Document](#exclamation-Document)
- [Scraping Data Visualization](#bar_chart-Scraping-Data-Visualization)
- [PPT](#open_file_folder-PPT)
- [Developer](#heavy_heart_exclamation-Developer)

## :pushpin: About

**Here's a information about Scraping and Website SINTA KEMDIKBUD :**

- Scraping adalah teknik pengambilan data secara otomatis dari situs web. Proses ini melibatkan penggunaan program untuk mengakses halaman web, mengekstrak informasi yang relevan, dan menyimpannya dalam format yang terstruktur untuk analisis lebih lanjut.

- SINTA (Science and Technology Index) adalah sebuah situs web yang dikelola oleh Kementerian Pendidikan, Kebudayaan, Riset, dan Teknologi (Kemendikbudristek) Republik Indonesia. Situs ini berfungsi sebagai platform untuk mengindeks dan meranking publikasi ilmiah serta para peneliti di Indonesia dan sebagai alat untuk mengukur dan memonitor kinerja peneliti dan institusi pendidikan tinggi di Indonesia, serta untuk meningkatkan kualitas dan produktivitas penelitian nasional. SINTA menyediakan profil-detail para peneliti, termasuk riwayat publikasi, metrik sitasi, afiliasi, dan informasi akademik lainnya yang relevan yang semuanya dapat digunakan untuk berbagai analisis dan pengambilan keputusan terkait penelitian dan pengembangan.

## :clipboard: Project Description

Pada proyek ini melakukan scraping data dari situs SINTA (Science and Technology Index) Kemdikbud dengan melakukan pengumpulan data dari bagian authors yang meliputi nama, sinta id, departemen, universitas dan sinta score overall. Tujuannya untuk mengetahui informasi departemen, universitas maupun score overall dari masing-masing nama peneliti yang tersedia dalam situs sinta sehingga dapat mengevaluasi kontribusi individu peneliti terhadap literatur ilmiah melalui SINTA score overall maupun untuk memonitor tren penelitian, mengidentifikasi potensi kolaborasi, dan membandingkan kinerja antar peneliti serta institusi.

Data diambil sebanyak 30 data yang mencakup:

- Nama: Nama lengkap dari peneliti yang terdaftar dalam SINTA.
- SINTA ID: Identifikasi unik yang digunakan dalam sistem SINTA untuk mengidentifikasi peneliti.
- Unit atau bagian di universitas tempat peneliti terafiliasi atau bekerja.
- Universitas: Institusi pendidikan tinggi di mana peneliti berafiliasi.
- SINTA Score Overall: Skor keseluruhan dari SINTA yang mencerminkan kinerja peneliti berdasarkan berbagai faktor seperti publikasi, sitasi, dan aktivitas ilmiah lainnya.

## :exclamation: Document

```
{"_id":{"$oid":"6677c0e2111b7755e90b5491"},"NAMA":"ASEP BAYU DANI NANDIYANTO","SINTA_ID":"5974504","DEPT":"Kimia (S2)","UNIV":"Universitas Pendidikan Indonesia","SCORE":"15.992"}
```
## :bar_chart: Scraping Data Visualization

Berikut merupakan link hasil visualisasi data scraping melalui Rpubs : http://rpubs.com/yunnamentari/Visualisasi-Data-Scraping

## :open_file_folder: PPT

Berikut merupakan file PPT yang dapat di akses melalui : https://ipb.link/ppt-scraping-data

## :heavy_heart_exclamation: Developer

[Yunna Mentari Indah](https://github.com/yunnamentari) (G1501231017)
