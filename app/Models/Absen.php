<?php

// app/Models/Absen.php
namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Absen extends Model
{
    use HasFactory;


    protected $table = 'absen';
    protected $fillable = [
        'id', 'location', 'status', 'date', 'data_pkl_id'
    ];

    public function dataPkl()
    {
        return $this->belongsTo(DataPkl::class, 'data_pkl_id');
    }
}

