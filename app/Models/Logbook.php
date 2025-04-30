<?php

// app/Models/Logbook.php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Logbook extends Model
{
    use HasFactory;
    protected $table = 'logbook';
    protected $fillable = [
        'week_number', 'file_pdf', 'data_pkl_id'
    ];

    public function dataPkl()
    {
        return $this->belongsTo(DataPkl::class, 'data_pkl_id');
    }

    public function komentarLogbook()
    {
        return $this->hasMany(KomentarLogbook::class, 'logbook_id');
    }
}

