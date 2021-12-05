<?php
/*
 * File name: StatusChangedBooking.php
 * Last modified: 2021.09.15 at 13:28:01
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2021
 */

namespace App\Notifications;

use App\Models\Booking;
use Benwilkins\FCM\FcmMessage;
use Illuminate\Bus\Queueable;
use Illuminate\Notifications\Messages\MailMessage;
use Illuminate\Notifications\Notification;

class StatusChangedBooking extends Notification
{
    use Queueable;

    /**
     * @var Booking
     */
    public $booking;

    /**
     * Create a new notification instance.
     *
     * @return void
     */
    public function __construct(Booking $booking)
    {
        $this->booking = $booking;
    }

    /**
     * Get the notification's delivery channels.
     *
     * @param mixed $notifiable
     * @return array
     */
    public function via($notifiable)
    {
        return ['database', 'fcm', 'mail'];
    }

    /**
     * Get the mail representation of the notification.
     *
     * @param mixed $notifiable
     * @return MailMessage
     */
    public function toMail($notifiable)
    {
        return (new MailMessage)
            ->markdown("notifications::booking", ['booking' => $this->booking])
            ->subject(trans('lang.notification_your_booking', ['booking_id' => $this->booking->id, 'booking_status' => $this->booking->bookingStatus->status]) . " | " . setting('app_name', ''))
            ->greeting(trans('lang.notification_your_booking', ['booking_id' => $this->booking->id, 'booking_status' => $this->booking->bookingStatus->status]))
            ->action(trans('lang.booking_details'), route('bookings.show', $this->booking->id));
    }

    public function toFcm($notifiable): FcmMessage
    {
        $message = new FcmMessage();
        $notification = [
            'title' => trans('lang.notification_status_changed_booking'),
            'body' => trans('lang.notification_your_booking', ['booking_id' => $this->booking->id, 'booking_status' => $this->booking->bookingStatus->status]),
            'icon' => $this->getEServiceMediaUrl(),
            'click_action' => "FLUTTER_NOTIFICATION_CLICK",
            'id' => 'App\\Notifications\\StatusChangedBooking',
            'status' => 'done',
        ];
        $data = $notification;
        $data['bookingId'] = $this->booking->id;
        $message->content($notification)->data($data)->priority(FcmMessage::PRIORITY_HIGH);

        return $message;
    }

    private function getEServiceMediaUrl(): string
    {
        if ($this->booking->e_service->hasMedia('image')) {
            return $this->booking->e_service->getFirstMediaUrl('image', 'thumb');
        } else {
            return asset('images/image_default.png');
        }
    }

    /**
     * Get the array representation of the notification.
     *
     * @param mixed $notifiable
     * @return array
     */
    public function toArray($notifiable)
    {
        return [
            'booking_id' => $this->booking['id'],
        ];
    }
}
