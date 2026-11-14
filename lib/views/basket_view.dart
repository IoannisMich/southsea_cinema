import 'package:flutter/material.dart';
import 'package:southsea_cinema/constants.dart';
import 'package:southsea_cinema/database/cinema_db.dart';
import 'package:southsea_cinema/models/booking.dart';
import 'package:southsea_cinema/models/booking_item.dart';
import 'package:southsea_cinema/models/ticket_item.dart';
import 'package:southsea_cinema/repositories/basket_repository.dart';
import 'package:southsea_cinema/widgets/nav_drawer.dart';
import 'package:southsea_cinema/widgets/primary_button.dart';

class BasketView extends StatefulWidget {
  const BasketView({super.key});

  @override
  State<BasketView> createState() {
    return _BasketViewState();
  }
}

class _BasketViewState extends State<BasketView> {
  String _confirmationMessage = '';
  List<Booking> _bookings = [];
  bool _loadingBookings = true;
  String _bookingsError = '';

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    try {
      final List<Booking> bookings =
          await CinemaDatabase.instance.getAllBookings();
      if (!mounted) {
        return;
      }
      setState(() {
        _bookings = bookings;
        _loadingBookings = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _bookingsError = 'Could not load bookings: $error';
        _loadingBookings = false;
      });
    }
  }

  String _buildSummary(List<TicketItem> items) {
    final List<String> parts = [];
    for (final TicketItem item in items) {
      parts.add('${item.quantity} x ${item.movie.title}');
    }
    return parts.join(', ');
  }

  String _formatDate(DateTime now) {
    final String day = now.day.toString().padLeft(2, '0');
    final String month = now.month.toString().padLeft(2, '0');
    final String hour = now.hour.toString().padLeft(2, '0');
    final String minute = now.minute.toString().padLeft(2, '0');
    return '$day/$month/${now.year} $hour:$minute';
  }

  Future<void> _checkout(
    BasketRepository basket,
    List<TicketItem> items,
  ) async {
    final String summary = _buildSummary(items);
    final double total = basket.getTotalDue();
    final String date = _formatDate(DateTime.now());
    final List<BookingItem> bookingItems = [];
    for (final TicketItem item in items) {
      bookingItems.add(
        BookingItem(
          movieId: item.movie.id,
          movieTitle: item.movie.title,
          unitPrice: item.movie.price,
          quantity: item.quantity,
        ),
      );
    }

    try {
      final CinemaDatabase database = CinemaDatabase.instance;
      final int bookingNumber = await database.getNextBookingNumber();
      final Booking booking = Booking(
        bookingNumber: bookingNumber,
        summary: summary,
        total: total,
        date: date,
        items: bookingItems,
      );

      await database.insertBooking(booking);
      basket.clear();
      if (!mounted) {
        return;
      }
      setState(() {
        _confirmationMessage = 'Booking $bookingNumber saved';
      });
      await _loadBookings();
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _confirmationMessage = 'Could not save your booking: $error';
      });
    }
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 32.0),
        child: Text(
          'Your basket is empty',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildLineItem(BasketRepository basket, TicketItem item, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.quantity} x ${item.movie.title}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text('£${item.lineTotal.toStringAsFixed(2)}'),
              ],
            ),
          ),
          IconButton(
            key: Key('delete_$index'),
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () {
              setState(() {
                basket.removeItem(index);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTotalRow(String label, String value, {bool emphasise = false}) {
    final TextStyle style;
    if (emphasise) {
      style = const TextStyle(fontWeight: FontWeight.bold, fontSize: 16);
    } else {
      style = const TextStyle();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(value, style: style),
        ],
      ),
    );
  }

  Widget _buildBasketList(BasketRepository basket, List<TicketItem> items) {
    final List<Widget> children = [];

    children.add(
      const Text(
        'Your basket',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
    children.add(const SizedBox(height: 16));

    for (int index = 0; index < items.length; index++) {
      final TicketItem item = items[index];
      children.add(_buildLineItem(basket, item, index));
    }

    children.add(const SizedBox(height: 24));
    children.add(
      _buildTotalRow(
        'Items subtotal',
        '£${basket.getSubtotal().toStringAsFixed(2)}',
      ),
    );
    children.add(
      _buildTotalRow(
        'Total to pay',
        '£${basket.getTotalDue().toStringAsFixed(2)}',
        emphasise: true,
      ),
    );
    children.add(const SizedBox(height: 24));

    children.add(
      SizedBox(
        width: double.infinity,
        child: PrimaryButton(
          label: 'Checkout',
          onPressed: () {
            _checkout(basket, items);
          },
        ),
      ),
    );

    if (_confirmationMessage.isNotEmpty) {
      children.add(const SizedBox(height: 12));
      children.add(
        Text(
          _confirmationMessage,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Widget _buildBookingCard(Booking booking) {
    final List<Widget> itemDetails = [];
    if (booking.items.isEmpty) {
      itemDetails.add(Text(booking.summary));
    } else {
      for (final BookingItem item in booking.items) {
        itemDetails.add(
          Text(
            '${item.quantity} x ${item.movieTitle} '
            'at £${item.unitPrice.toStringAsFixed(2)} each: '
            '£${item.lineTotal.toStringAsFixed(2)}',
          ),
        );
      }
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Booking #${booking.bookingNumber}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('£${booking.total.toStringAsFixed(2)}'),
              ],
            ),
            const SizedBox(height: 4),
            ...itemDetails,
            const SizedBox(height: 4),
            Text(
              booking.date,
              style: const TextStyle(fontSize: 12, color: cinemaFontMuted),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPastBookings() {
    final Widget section;
    if (_loadingBookings) {
      section = const Center(child: CircularProgressIndicator());
    } else if (_bookingsError.isNotEmpty) {
      section = Text(_bookingsError);
    } else if (_bookings.isEmpty) {
      section = const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Text(
          'No bookings yet',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    } else {
      final List<Widget> cards = [];
      for (final Booking booking in _bookings) {
        cards.add(_buildBookingCard(booking));
      }
      section = Column(children: cards);
    }
    return section;
  }

  @override
  Widget build(BuildContext context) {
    final BasketRepository basket = BasketRepository.instance;
    final List<TicketItem> items = basket.getItems();

    final Widget content;
    if (items.isEmpty) {
      if (_confirmationMessage.isNotEmpty) {
        content = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEmptyState(),
            const SizedBox(height: 12),
            Text(
              _confirmationMessage,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        );
      } else {
        content = _buildEmptyState();
      }
    } else {
      content = _buildBasketList(basket, items);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(appTitle),
      ),
      drawer: const NavDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            content,
            const SizedBox(height: 32),
            const Text(
              'Past bookings',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildPastBookings(),
          ],
        ),
      ),
    );
  }
}
