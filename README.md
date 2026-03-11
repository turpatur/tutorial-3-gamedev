## Implementasi Double Jump, Crouch, Dash, dan Animasi

Pada tutorial ini, saya mengimplementasikan **double jump**, **crouch**, dan **dash** beserta animasinya.

---

## Double Jump

Untuk implementasi double jump, saya menggunakan variabel `jump_count` dan `max_jumps`. `jump_count` diberi nilai `0` pada fungsi `_ready()`, sehingga saat objek pertama kali masuk ke scene akan terinisiasi dengan nilai `0`.

Ketika objek melompat, nilai `jump_count` akan bertambah satu. Player dapat melakukan lompatan lagi selama nilai `jump_count` masih kurang dari `max_jumps`, yang pada implementasi ini bernilai `2`. Dengan demikian, player dapat melakukan satu kali lompatan tambahan setelah lompatan pertama. `jump_count` akan di-reset ketika objek berada di atas floor.

---

## Dash (Double Tap 0.5 Detik)

Pada implementasi dash, saya menerapkan sistem dash ketika tombol kiri atau kanan ditekan dua kali dalam rentang waktu 0.5 detik tanpa cooldown. Jika kondisi terpenuhi, player akan dash ke arah yang sesuai selama 0.2 detik.

Untuk melakukan hal tersebut, diperlukan tracking waktu terakhir tombol ditekan. Saya menggunakan:

* `last_left_tap_time = -1`
* `last_right_tap_time = -1`
* `double_tap_time = 0.5`

Waktu saat ini dideteksi dengan:
`current_time = Time.get_ticks_msec() / 1000.0`

`Time.get_ticks_msec()` mengukur waktu sejak engine dinyalakan dalam milidetik, lalu dibagi 1000 agar menjadi detik. Untuk mendeteksi double tap kiri, sistem menghitung:
`current_time - last_left_tap_time`

Jika selisih waktu tersebut kurang dari atau sama dengan `double_tap_time` dan player tidak sedang crouch, maka fungsi `start_dash(direction)` akan dijalankan. Setelah itu, `last_left_tap_time` akan di-assign dengan nilai `current_time`. Mekanisme yang sama berlaku untuk tombol kanan.

Fungsi `start_dash()` akan:

* Mengubah `is_dashing` menjadi `true`.
* Mengisi `dash_time_left` dengan `dash_duration`.
* Menentukan `dash_direction` (`-1` untuk kiri, `1` untuk kanan).

Saat dash aktif, player akan bergerak di sumbu x sesuai:
`velocity.x = dash_direction * dash_speed`

Durasi dash berkurang setiap frame dengan:
`dash_time_left -= delta`

Jika `dash_time_left` kurang dari atau sama dengan `0`, maka `is_dashing` akan berubah menjadi `false` dan dash berhenti.

---

## Crouch

Pada implementasi crouch, saya membuat player:

1. Bergerak lebih lambat saat crouch.
2. Dapat melakukan *forced down dash* (menarik diri ke bawah saat di udara).

Crouch dikontrol dengan variabel `is_crouching`, yang aktif ketika player menekan tombol crouch dan tidak sedang dash.

Untuk efek turun cepat saat di udara, saya menggunakan:
`velocity.y += delta * gravity * 20`

Angka `20` digunakan sebagai modifier percepatan ke bawah. Untuk memperlambat gerakan horizontal saat crouch, saya menggunakan variabel `crouch_speed` dengan nilai `100`. Ketika player bergerak dalam kondisi crouch, maka kecepatan horizontal menggunakan `crouch_speed` sehingga lebih lambat dibanding `walk_speed`.

---

## Implementasi Animasi dengan AnimatedSprite2D

Saya menggunakan **AnimatedSprite2D** sebagai child dari node Player. Animasi diatur menggunakan **SpriteFrames**. Frame animasi dipilih dari spritesheet dengan mengatur grid dan memilih bagian yang sesuai untuk masing-masing animasi.

State animasi yang digunakan:

* `player_run`
* `player_jump`
* `player_idle`
* `player_crouch`

Kondisi aktivasinya:

* `player_run`: aktif ketika `velocity.x` tidak sama dengan `0`.
* `player_jump`: aktif ketika player tidak berada di atas floor.
* `player_crouch`: aktif ketika player menekan tombol crouch.
* `player_idle`: aktif ketika player tidak bergerak dan tidak crouch.

Sprite akan menghadap ke arah yang sesuai dengan mengatur `sprite.flip_h`. Nilai tersebut akan aktif ketika bergerak ke kiri dan kembali normal ketika bergerak ke kanan.

---

## Update Tutorial 5

### Perubahan Utama:

* Menambahkan musuh dan mekanik baru berupa **stomp**.
* Menambahkan efek suara ke musuh (spatial audio).
* Menambahkan Background Music (BGM) ke level utama.

### Mekanik Stomp

Saya menggunakan variabel baru `downward_attack` untuk menandakan status pemain saat melakukan *downward dash*. Stomp diimplementasikan menggunakan **Area2D** dan **CollisionShape2D** sebagai hitbox.

Ketika mengenai body "enemy" dari atas:

1. `downward_attack` kembali ke `false`.
2. Player akan *bounce* ke atas dengan `velocity.y = jump_speed * 0.7`.
3. Memanggil method `body.stomped()` pada musuh.
4. Musuh mengaktifkan status `is_dead`, menghentikan pergerakan, memutar animasi `skeleton_death`, dan memainkan `kill_sound`. Objek musuh dihapus dari scene setelah suara selesai.

### AI Musuh (Skeleton)

Skeleton melakukan patroli dengan jarak 100 px. Jika posisi `global_x` mencapai batas awal + distance, musuh akan berbalik arah.

Implementasi suara patroli menggunakan loop dengan delay:

```gdscript
audio.play()
await audio.finished
await get_tree().create_timer(sound_delay).timeout

```

Volume suara bersifat relatif terhadap posisi player menggunakan **AudioStreamPlayer2D**. Pengaturan dilakukan pada properti **Attenuation** dan **Max Distance** agar suara mengecil saat menjauh.

### Background Music (BGM)

BGM menggunakan **AudioStreamPlayer** (non-spatial) agar volume konstan di seluruh level. File audio diedit di Audacity agar selaras dengan timing loop. Loop diatur pada Godot dengan *offset* `7.037` detik agar transisi musik berjalan mulus antara `0:07.037` hingga `2:11.481`.

---

## Referensi

* [Triple Jump Function Stuck - Godot Forum](https://forum.godotengine.org/t/triple-jump-function-stuck/126160)
* [Flipping Sprite Around - Godot Forum](https://forum.godotengine.org/t/flipping-sprite-around/40427)
* [2D Sprite Animation - Godot Docs](https://docs.godotengine.org/en/stable/tutorials/2d/2d_sprite_animation.html)
* [How to Implement a Dash - Godot Forum](https://forum.godotengine.org/t/how-to-implement-a-dash/62066/9)
* [Disabling Crouch Mid-air - Godot Forum](https://forum.godotengine.org/t/need-help-with-disabling-crouch-while-mid-air/79101)

## Sumber Aset Tutorial 5

* [Bone Crack SFX](https://samplefocus.com/samples/bone-crack-sfx-rattle/complementary)
* [Monsters Creatures Fantasy Asset](https://luizmelo.itch.io/monsters-creatures-fantasy)
* [Fahhh SFX](https://www.myinstants.com/en/instant/fahhh-42300/)
* [Dova-s BGM](https://dova-s.jp/bgm/detail/23153)
