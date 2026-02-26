## Implementasi Double Jump dan Animasi

Pada tutorial ini, saya mengimplementasikan **double jump** beserta animasi.

Untuk implementasi double jump, saya menggunakan variabel `jump_count` dan `max_jumps`. `jump_count` saya beri nilai `0` ketika `_ready()`, sehingga saat objek pertama kali masuk ke scene akan terinisiasi dengan nilai `0`.

Kemudian, ketika objek melompat, nilai `jump_count` bertambah satu. Player dapat melakukan lompatan lagi ketika nilai `jump_count` kurang dari `max_jumps`, yang pada implementasi ini bernilai `2`. Dengan demikian, player dapat melakukan satu kali lompatan tambahan setelah lompatan pertama.

`jump_count` akan di-reset ketika objek berada di atas floor.

---

## Implementasi Animasi dengan AnimatedSprite2D

Selain itu, saya mengimplementasikan animasi pada object player menggunakan `AnimatedSprite2D`. Node `AnimatedSprite2D` saya letakkan sebagai child dari node `Player`, lalu animasi diatur menggunakan `SpriteFrames`.

Saya melakukan seleksi frame untuk dijadikan animasi dari spritesheet dengan cara mengatur grid dan memilih bagian grid yang sesuai untuk setiap animasi.

Dari hasil tersebut, saya memilih tiga state pemain, yaitu:

- `player_run`
- `player_jump`
- `player_idle`

Kondisi aktivasinya adalah sebagai berikut:

- `player_run` aktif ketika player bergerak (nilai `velocity.x` tidak sama dengan `0`).
- `player_jump` aktif ketika player tidak berada di atas floor.
- Selain kedua kondisi tersebut, maka `player_idle` akan aktif.

Sprite juga akan menghadap ke arah yang sesuai ketika bergerak ke kanan atau ke kiri dengan mengatur nilai `sprite.flip_h`. Nilai tersebut akan di-flip ketika bergerak ke kiri dan dikembalikan ketika bergerak ke kanan.

---

## Referensi

- https://forum.godotengine.org/t/triple-jump-function-stuck/126160
- https://forum.godotengine.org/t/flipping-sprite-around/40427
- https://docs.godotengine.org/en/stable/tutorials/2d/2d_sprite_animation.html