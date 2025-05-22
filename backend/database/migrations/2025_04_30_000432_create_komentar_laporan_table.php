<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('komentar_laporan', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('laporan_pkl_id');
            $table->unsignedBigInteger('dosen_id');
            $table->text('comment');
            $table->timestamps();
        
            $table->foreign('laporan_pkl_id')->references('id')->on('laporan_pkl');
            $table->foreign('dosen_id')->references('id')->on('users');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('komentar_laporan');
    }
};
