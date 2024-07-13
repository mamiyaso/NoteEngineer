# Note Engineer: Kişisel Not Alma Uygulamanız 🔐

Note Engineer, Flutter ile geliştirilmiş ve Supabase ile desteklenen, kullanıcı dostu ve güçlü bir not alma uygulamasıdır. **En önemlisi, notlarınızın güvenliği için uçtan uca şifreleme kullanır.** Düşüncelerinizi, fikirlerinizi veya yapılacaklar listelerinizi gizli tutarken kolayca yakalamanıza, düzenlemenize ve yönetmenize yardımcı olmak için tasarlanmıştır.

## Özellikler:

- **Güvenli Notlar:** Note Engineer, AES şifrelemesi kullanarak notlarınızı hem cihazınızda hem de Supabase'te şifreler. Bu sayede, verileriniz her zaman güvende kalır. 
- **Not Oluşturma ve Düzenleme:** Düşüncelerinizi, fikirlerinizi veya yapılacaklar listelerinizi hızlıca yazın. Metninizi kolayca biçimlendirin ve başlıklar ekleyin.
- **Matematiksel Hesaplamalar:** Notlarınızın içinden karmaşık matematiksel hesaplamalar yapın. Çeşitli matematiksel semboller, fonksiyonlar ve operatörler kullanın.
- **Favoriler:** Önemli notlarınızı kolayca erişim için yıldızlayın.
- **Düzenleme ve Arama:** Notlarınızı anahtar kelimeler veya ifadeler kullanarak arayın.
- **Çöp Kutusu:** Yanlışlıkla not mu sildiniz? Endişelenmeyin! Çöp kutusundan kurtarın.
- **Metin Dosyasına Kaydetme:** Notlarınızı paylaşmak veya yedeklemek için düz metin dosyasına aktarın.
- **Güvenli ve Senkronize Edilmiş:** Notlarınız, verilerinizin güvenli ve her cihazdan erişilebilir olmasını sağlayan Supabase'de güvenli bir şekilde saklanır.
- **Tema Seçenekleri:** Açık tema, koyu tema veya kendi özel temanızı seçin. Vurgu rengi, arkaplan rengi ve metin rengini özelleştirin.
- **Kategorilenmiş Hesap Makineleri:** Hesap makinelerine kolayca erişin ve farklı kategoriler (Tarih & Zaman, Dönüşümler, Matematik) arasında gezinin.
    - **Tarih & Zaman:**
        - Yaş Hesaplayıcı
        - Tarih Farkı Hesaplayıcı
    - **Dönüşümler:**
        - Zaman Hesaplayıcı
        - Alan Hesaplayıcı
        - Uzunluk Hesaplayıcı
        - Kütle Hesaplayıcı
        - Sıcaklık Hesaplayıcı
        - Hacim Hesaplayıcı
        - Sayı Sistemi Dönüştürücü
    - **Matematik:**
        - Basit Hesap Makinesi

## Kurulum

Note Engineer'i indirmek ve kullanmaya başlamak için aşağıdaki adımları izleyin:

1.  **GitHub Releases sayfasına gidin:** https://github.com/mamiyaso/NoteEngineer/releases
2.  **Uygun APK dosyasını indirin:** Cihazınızın işlemci türüne uygun APK dosyasını seçin.
3.  **APK dosyasını kurun:** APK dosyasına dokunun ve kurulum talimatlarını izleyin.

## Windows için Kurulum:

1.  **GitHub Releases sayfasına gidin:** https://github.com/mamiyaso/NoteEngineer/releases
2.  **Zip dosyasını indirin:** Windows için Zip dosyasını indirin.
3.  **Zip dosyasını ayıklayın:** İndirilen Zip dosyasını bilgisayarınızda bir yere ayıklayın.
4.  **Flutter.exe dosyasını çalıştırın:** Ayıklanan klasördeki "flutter.exe" dosyasına çift tıklayın.

## Ek Bilgiler:

-   **APK dosyasını kurmak için cihazınızın bilinmeyen kaynaklardan uygulama yüklemesine izin vermeniz gerekebilir.**
-   **EXE dosyasını kurmak için cihazınızın bilinmeyen kaynaklardan uygulama yüklemesine izin vermeniz gerekebilir.**

## Gelecek Destek:

Yakında macOS, iOS, Linux ve web platformları için destek eklenecek. Bu platformlar için kurulum talimatları da GitHub Releases sayfasına eklenecektir.

  
Note Engineer'i kullanmaya başladıktan sonra sorularınız varsa lütfen GitHub sayfamızda bize ulaşmaktan çekinmeyin.

## Bağımlılıklar

Uygulamanın geliştirilmesinde aşağıdaki bağımlılıklar kullanılmıştır:

* **flutter:**
* **math_expressions:** 
* **supabase_flutter:** 
* **http:** 
* **path_provider:**
* **provider:**
* **flutter_colorpicker:**
* **file_picker:** 
* **flutter_dotenv:** 
* **intl:** 
* **shared_preferences:** 
* **cupertino_icons:**
* **flutter_launcher_icons:**
* **encrypt:** 
* **pointycastle:** 
* **flutter_secure_storage:** 

## Gelecek sürümlerde uygulamaya eklenecek özellikler:

* **Dijital mürekkep tanıma (Google's ML Kit Digital Ink Recognition for Flutter):**  Kullanıcıların doğrudan ekrana yazdıkları veya çizdikleri notları dijital karakterlere dönüştürme.
* **Belge tarama (MLKit Document Scanner):**  Kullanıcıların cihaz kamerasını kullanarak belgeleri tarayabilme ve yüksek kaliteli dijital kopyalar elde edebilme.
* **Görüntü metin tanıma (Google's ML Kit Text Recognition for Flutter):**  Kullanıcıların çektiği fotoğraflardaki yazıları otomatik olarak tanıyarak düz metin olarak notlarına ekleyebilme.
* **Google Keep API:** Not defteri uygulamasına Google Keep'in özelliklerini entegre etme, örneğin not oluşturma, düzenleme, silme, etiket ekleme, hatırlatıcı ayarlama gibi. 
* **PDF dışa aktarma:**  Kullanıcıların notlarını ve hesaplamalarını PDF formatında dışa aktarabilme.
* **OCR taraması:** Fotoğraflarda bulunan metinleri OCR (Optik Karakter Tanıma) kullanarak aranabilir hale getirme.
* **Daha Fazla Giriş Yapma Seçeneği:** Kullanıcıların Google, Facebook vb. gibi diğer platformlar aracılığıyla giriş yapmalarına olanak sağlamak için daha fazla giriş seçeneği eklenecektir.
* **Daha Fazla Dil Desteği:** Uygulamanın daha geniş bir kitleye ulaşması için daha fazla dil seçeneği eklenecektir.


**Bu özellikler, uygulamaya eklendikçe, GitHub Releases sayfasında güncellemeler yayınlanacaktır.**

## Lisans

Note Engineer, MIT Lisansı altında lisanslanmıştır. Daha fazla bilgi için LICENSE dosyasına bakın.

![ezgif com-apng-maker-1 1](https://github.com/user-attachments/assets/5fb8b0bd-b3b8-44d8-ab15-c038e4c69c2c)
