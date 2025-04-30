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
        Schema::create('laporan_pkl', function (Blueprint $table) {
            $table->id();
            $table->date('report_date');
            $table->string('file_attachment', 255);
            $table->enum('status', ['submitted', 'reviewed', 'revised']);
            $table->unsignedBigInteger('users_id'); // mahasiswa
            $table->timestamps();
        
            $table->foreign('users_id')->references('id')->on('users');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('laporan_pkl');
    }
};
