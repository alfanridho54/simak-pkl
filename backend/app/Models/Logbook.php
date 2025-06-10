<?php

// app/Models/Logbook.php
namespace App\Models;

use Illuminate\Database\Eloquent\Casts\Attribute;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Storage;

class Logbook extends Model
{
    use HasFactory;
    protected $table = 'logbook';
    protected $fillable = [
        'week_number', 'file_pdf', 'data_pkl_id', 'kegiatan'
    ];

    public function dataPkl()
    {
        return $this->belongsTo(DataPkl::class, 'data_pkl_id');
    }

    public function komentarLogbook()
    {
        return $this->hasMany(KomentarLogbook::class, 'logbook_id');
    }

    protected function filePdf(): Attribute
    {
        return Attribute::make(
            get: fn ($value) => $value ? Storage::disk('public')->url($value) : null,
        );
    }
}

