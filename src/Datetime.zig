const time = @import("std").time;

year: u16,
month: u4,
day: u5,
hours: u5,
minutes: u6,
seconds: u6,
miliseconds: u10,
nanoseconds: u30,

pub fn get() @This() {
    const ts_mili: u64 = @intCast(time.milliTimestamp());
    const ts_nano: u64 = @intCast(time.nanoTimestamp());
    const ts_sec: u64 = @intCast(@divTrunc(ts_mili, time.ms_per_s));
    const miliseconds: u10 = @intCast(ts_mili - ts_sec * time.ms_per_s);
    const nanoseconds: u30 = @intCast(ts_nano - ts_sec * time.ns_per_s);
    const epoch_seconds = time.epoch.EpochSeconds{ .secs = ts_sec };
    const epoch_day = epoch_seconds.getEpochDay();
    const year_day = epoch_day.calculateYearDay();
    const month_date = year_day.calculateMonthDay();

    const year = year_day.year;
    const month = time.epoch.Month.numeric(month_date.month);
    const day = month_date.day_index + 1;
    const hours = epoch_seconds.getDaySeconds().getHoursIntoDay();
    const minutes = epoch_seconds.getDaySeconds().getMinutesIntoHour();
    const seconds = epoch_seconds.getDaySeconds().getSecondsIntoMinute();
    return .{ .year = year, .month = month, .day = day, .hours = hours, .minutes = minutes, .seconds = seconds, .miliseconds = miliseconds, .nanoseconds = nanoseconds };
}
