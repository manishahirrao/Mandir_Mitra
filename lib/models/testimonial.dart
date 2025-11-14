class Testimonial {
  final String id;
  final String customerName;
  final String customerPhoto;
  final double rating;
  final String text;
  final String ritualPerformed;

  Testimonial({
    required this.id,
    required this.customerName,
    required this.customerPhoto,
    required this.rating,
    required this.text,
    required this.ritualPerformed,
  });

  static List<Testimonial> getMockTestimonials() {
    return [
      Testimonial(
        id: '1',
        customerName: 'Priya Sharma',
        customerPhoto: 'https://i.pravatar.cc/150?img=1',
        rating: 5.0,
        text: 'The Maa Kali puja was performed with such devotion. I felt the divine presence throughout the ritual. Highly recommended!',
        ritualPerformed: 'Maa Kali Puja',
      ),
      Testimonial(
        id: '2',
        customerName: 'Rajesh Kumar',
        customerPhoto: 'https://i.pravatar.cc/150?img=12',
        rating: 5.0,
        text: 'Amazing experience! The pandit was very knowledgeable and the live streaming made me feel like I was there in person.',
        ritualPerformed: 'Ram Janmabhoomi Darshan',
      ),
      Testimonial(
        id: '3',
        customerName: 'Anita Desai',
        customerPhoto: 'https://i.pravatar.cc/150?img=5',
        rating: 5.0,
        text: 'The Satyanarayan Katha brought peace to our family. The prasad arrived fresh and the entire process was seamless.',
        ritualPerformed: 'Satyanarayan Katha',
      ),
      Testimonial(
        id: '4',
        customerName: 'Vikram Singh',
        customerPhoto: 'https://i.pravatar.cc/150?img=15',
        rating: 5.0,
        text: 'Excellent service! The Navagraha Shanti Puja helped resolve many issues in my life. Thank you Mandir Mitra!',
        ritualPerformed: 'Navagraha Shanti Puja',
      ),
      Testimonial(
        id: '5',
        customerName: 'Meera Patel',
        customerPhoto: 'https://i.pravatar.cc/150?img=9',
        rating: 5.0,
        text: 'The Lakshmi Puja was beautifully conducted. I received the aashirwad box with all the sacred items. Blessed experience!',
        ritualPerformed: 'Lakshmi Puja',
      ),
    ];
  }
}
