---
icon: fa-solid fa-basket-shopping
order: 3
title: Shop prices
---

{% assign shop = site.data.shop_prices %}
{% assign items = shop.Items | default: shop.items %}
{% assign vehicles = shop.Vehicles | default: shop.vehicles %}

## Item prices

<table>
	<thead>
		<tr>
			<th>Icon</th>
			<th>ID</th>
			<th>Item</th>
			<th>Buy</th>
			<th>Sell</th>
		</tr>
	</thead>
	<tbody>
		{% if items and items.size > 0 %}
			{% for item in items %}
				{% assign item_buy = item.BuyPrice | default: 0 | plus: 0 %}
				{% assign item_sell = item.SellPrice | default: 0 | plus: 0 %}
				{% assign item_url = item.url %}
				<tr>
					<td>
						{% if item.iconUrl %}
							<img src="{{ item.iconUrl }}" alt="{{ item.ItemName | default: item.Name }}" width="48" height="48" loading="lazy">
						{% else %}
							-
						{% endif %}
					</td>
					<td>{{ item.ID }}</td>
					<td>
						{% if item_url %}
							<a href="https://restoremonarchy.com{{ item_url }}" target="_blank" rel="noopener noreferrer">{{ item.ItemName | default: item.Name }}</a>
						{% else %}
							{{ item.ItemName | default: item.Name }}
						{% endif %}
					</td>
					<td>{{ item_buy | round: 0 }}</td>
					<td>{% if item_sell == 0 %}{% else %}{{ item_sell | round: 0 }}{% endif %}</td>
				</tr>
			{% endfor %}
		{% else %}
			<tr>
				<td>-</td>
				<td>-</td>
				<td>No items available</td>
				<td>-</td>
				<td>-</td>
			</tr>
		{% endif %}
	</tbody>
</table>

## Vehicle prices

<table>
	<thead>
		<tr>
			<th>ID</th>
			<th>Vehicle</th>
			<th>Buy</th>
		</tr>
	</thead>
	<tbody>
		{% if vehicles and vehicles.size > 0 %}
			{% for vehicle in vehicles %}
				{% assign vehicle_buy = vehicle.BuyPrice | default: 0 | plus: 0 %}
				<tr>
					<td>{{ vehicle.ID }}</td>
					<td>{{ vehicle.VehicleName | default: vehicle.Name }}</td>
					<td>{{ vehicle_buy | round: 0 }}</td>
				</tr>
			{% endfor %}
		{% else %}
			<tr>
				<td>-</td>
				<td>No vehicles available</td>
				<td>-</td>
			</tr>
		{% endif %}
	</tbody>
</table>