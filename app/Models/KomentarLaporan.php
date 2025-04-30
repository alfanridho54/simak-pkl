<?php

// app/Models/KomentarLaporan.php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class KomentarLaporan extends Model
{
    use HasFactory;
    protected $table = 'komentar_laporan';
    protected $fillable = [
        'laporan_pkl_id', 'dosen_id', 'comment'
    ];

    public function laporanPkl()
    {
        return $this->belongsTo(LaporanPkl::class, 'laporan_pkl_id');
    }

    public function dosen()
    {
        return $this->belongsTo(User::class, 'dosen_id');
    }
}
