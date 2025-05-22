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
        Schema::create('data_pkl', function (Blueprint $table) {
            $table->id();
            $table->string('company_name', 255);
            $table->text('company_address');
            $table->string('contact_person', 255);
            $table->unsignedBigInteger('dosen_pembimbing'); // foreign key ke users
            $table->enum('status', ['pending', 'approved', 'rejected']);
            $table->unsignedBigInteger('users_id'); // mahasiswa
            $table->timestamps();
        
            $table->foreign('dosen_pembimbing')->references('id')->on('users');
            $table->foreign('users_id')->references('id')->on('users');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('data_pkl');
    }
};
