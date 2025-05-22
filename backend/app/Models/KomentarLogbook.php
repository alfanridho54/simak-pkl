<?php

// app/Models/KomentarLogbook.php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class KomentarLogbook extends Model
{
    use HasFactory;
    protected $table = 'komentar_logbook';
    protected $fillable = [
        'logbook_id', 'dosen_id', 'comment'
    ];

    public function logbook()
    {
        return $this->belongsTo(Logbook::class, 'logbook_id');
    }

    public function dosen()
    {
        return $this->belongsTo(User::class, 'dosen_id');
    }
}

