<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class DataPkl extends Model
{
    use HasFactory;

    protected $table = 'data_pkl';
    protected $fillable = [
        'company_name', 'company_address', 'contact_person', 'dosen_pembimbing', 'status', 'users_id'
    ];

    public function mahasiswa()
    {
        return $this->belongsTo(User::class, 'users_id');
    }

    public function dosenPembimbing()
    {
        return $this->belongsTo(User::class, 'dosen_pembimbing');
    }

    public function absen()
    {
        return $this->hasMany(Absen::class, 'data_pkl_id');
    }

    public function logbook()
    {
        return $this->hasMany(Logbook::class, 'data_pkl_id');
    }
}
