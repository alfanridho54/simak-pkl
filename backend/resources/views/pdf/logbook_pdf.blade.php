<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Logbook Minggu ke-{{ $logbook->week_number }}</title>
    <style>
        body { font-family: 'Helvetica', sans-serif; line-height: 1.6; color: #333; }
        .header { text-align: center; margin-bottom: 20px; }
        .header h1 { margin: 0; font-size: 24px; }
        .header p { margin: 5px 0; font-size: 14px; }
        .content-table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        .content-table th, .content-table td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        .content-table th { background-color: #f2f2f2; font-weight: bold; }
        .footer { margin-top: 40px; text-align: right; font-size: 12px; }
    </style>
</head>
<body>

    <div class="header">
        <h1>LOGBOOK KEGIATAN PRAKTIK KERJA LAPANGAN</h1>
        <p>Tahun Akademik 2024/2025</p>
    </div>

    <table class="content-table">
        <tr>
            <th style="width: 30%;">Nama Mahasiswa</th>
            <td>{{ $logbook->dataPkl->mahasiswa->name ?? 'N/A' }}</td>
        </tr>
        <tr>
            <th>NIM / NPM</th>
            <td>{{ $logbook->dataPkl->mahasiswa->nim ?? 'N/A' }}</td>
        </tr>
        <tr>
            <th>Perusahaan PKL</th>
            <td>{{ $logbook->dataPkl->company_name ?? 'N/A' }}</td>
        </tr>
        <tr>
            <th>Dosen Pembimbing</th>
            <td>{{ $logbook->dataPkl->dosenPembimbing->name ?? 'N/A' }}</td>
        </tr>
        <tr>
            <th>Logbook Minggu Ke-</th>
            <td>{{ $logbook->week_number }}</td>
        </tr>
        <tr>
            <th>Tanggal Dibuat</th>
            <td>{{ \Carbon\Carbon::parse($logbook->created_at)->translatedFormat('d F Y') }}</td>
        </tr>
    </table>

    <div style="margin-top: 30px;">
        <h2>Uraian Kegiatan Mingguan</h2>
        <p>
            {!! nl2br(e($logbook->kegiatan ?? 'Tidak ada uraian kegiatan yang diisi.')) !!}
        </p>
    </div>

    <div class="footer">
        <p>Depok, {{ date('d F Y') }}</p>
        <br><br><br>
        <p>_______________________</p>
        <p>({{ $logbook->dataPkl->mahasiswa->name ?? 'Mahasiswa' }})</p>
    </div>

</body>
</html>