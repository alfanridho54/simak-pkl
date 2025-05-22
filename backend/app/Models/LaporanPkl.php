<?php

// app/Models/LaporanPkl.php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class LaporanPkl extends Model
{
    use HasFactory;
    protected $table = 'laporan_pkl';
    protected $fillable = [
        'report_date', 'file_attachment', 'status', 'data_pkl_id','users_id'
    ];

    public function mahasiswa()
    {
        return $this->belongsTo(User::class, 'users_id');
    }

    public function komentarLaporan()
    {
        return $this->hasMany(KomentarLaporan::class, 'laporan_pkl_id');
    }

    public function dataPkl()
{
    return $this->belongsTo(DataPkl::class, 'data_pkl_id');
}
}

