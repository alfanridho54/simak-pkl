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
        Schema::create('logbook', function (Blueprint $table) {
            $table->id();
            $table->integer('week_number');
            $table->string('file_pdf', 255);
            $table->unsignedBigInteger('data_pkl_id');
            $table->timestamps();
        
            $table->foreign('data_pkl_id')->references('id')->on('data_pkl');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('logbook');
    }
};
