<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Casts\Attribute; // <-- IMPORT
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Storage; // <-- IMPORT

class LaporanPkl extends Model
{
    use HasFactory;
    protected $table = 'laporan_pkl';
    protected $fillable = [
        'report_date', 'file_attachment', 'status', 'data_pkl_id','users_id'
    ];

    protected function fileAttachment(): Attribute
    {
        return Attribute::make(
           
            get: fn ($value) => $value ? Storage::disk('public')->url($value) : null,
        );
    }
    // --- AKHIR PENAMBAHAN ---

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