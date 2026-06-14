---
icon: fa-solid fa-basket-shopping
order: 3
title: Shop prices
---

{% assign shop = site.data.shop_prices %}
{% assign items = shop.Items | default: shop.items %}
{% assign vehicles = shop.Vehicles | default: shop.vehicles %}

<style>
	#shop-items-list table,
	#shop-vehicles-list table {
		width: 100%;
	}

	#shop-items-list tbody tr,
	#shop-vehicles-list tbody tr {
		height: 64px;
	}

	#shop-items-list tbody td,
	#shop-vehicles-list tbody td {
		vertical-align: middle;
	}

	#shop-items-list .icon-cell,
	#shop-vehicles-list .icon-cell {
		width: 56px;
	}

	#shop-items-list .icon-image,
	#shop-vehicles-list .icon-image {
		display: block;
		width: auto;
		height: auto;
		max-width: 48px;
		max-height: 48px;
		margin: 0 auto;
	}
</style>

## Item prices

<div id="shop-items-list">
	<p>
		<input class="search" type="search" placeholder="Search items..." aria-label="Search items">
	</p>
	<table>
		<thead>
			<tr>
				<th>Icon</th>
				<th>
					<button class="sort" data-sort="item-type" type="button">Type</button>
				</th>
				<th>
					<button class="sort" data-sort="item-id" type="button">ID</button>
				</th>
				<th>
					<button class="sort" data-sort="item-name" type="button">Item</button>
				</th>
				<th>
					<button class="sort" data-sort="item-buy" type="button">Buy</button>
				</th>
				<th>
					<button class="sort" data-sort="item-sell" type="button">Sell</button>
				</th>
			</tr>
		</thead>
		<tbody class="list">
			{% if items and items.size > 0 %}
				{% for item in items %}
					{% assign item_buy = item.BuyPrice | default: 0 | plus: 0 %}
					{% assign item_sell = item.SellPrice | default: 0 | plus: 0 %}
					{% assign item_url = item.url %}
					<tr>
						<td class="icon-cell">
							{% if item.iconUrl %}
								<img class="icon-image" src="{{ item.iconUrl }}" alt="{{ item.ItemName | default: item.Name }}" loading="lazy">
							{% endif %}
						</td>
						<td class="item-type">{{ item.assetType }}</td>
						<td class="item-id">{{ item.ID }}</td>
						<td class="item-name">
							{% if item_url %}
								<a href="https://restoremonarchy.com{{ item_url }}" target="_blank" rel="noopener noreferrer">{{ item.ItemName | default: item.Name }}</a>
							{% else %}
								{{ item.ItemName | default: item.Name }}
							{% endif %}
						</td>
						<td class="item-buy">{{ item_buy | round: 0 }}</td>
						<td class="item-sell">{% if item_sell == 0 %}{% else %}{{ item_sell | round: 0 }}{% endif %}</td>
					</tr>
				{% endfor %}
			{% else %}
				<tr>
					<td class="icon-cell"></td>
					<td class="item-type"></td>
					<td class="item-id"></td>
					<td class="item-name">No items available</td>
					<td class="item-buy"></td>
					<td class="item-sell"></td>
				</tr>
			{% endif %}
		</tbody>
	</table>
</div>

## Vehicle prices

<div id="shop-vehicles-list">
	<p>
		<input class="search" type="search" placeholder="Search vehicles..." aria-label="Search vehicles">
	</p>
	<table>
		<thead>
			<tr>
				<th>Icon</th>
				<th>
					<button class="sort" data-sort="vehicle-type" type="button">Type</button>
				</th>
				<th>
					<button class="sort" data-sort="vehicle-id" type="button">ID</button>
				</th>
				<th>
					<button class="sort" data-sort="vehicle-name" type="button">Vehicle</button>
				</th>
				<th>
					<button class="sort" data-sort="vehicle-buy" type="button">Buy</button>
				</th>
			</tr>
		</thead>
		<tbody class="list">
			{% if vehicles and vehicles.size > 0 %}
				{% for vehicle in vehicles %}
					{% assign vehicle_buy = vehicle.BuyPrice | default: 0 | plus: 0 %}
					{% assign vehicle_url = vehicle.url %}
					<tr>
						<td class="icon-cell">
							{% if vehicle.iconUrl %}
								<img class="icon-image" src="{{ vehicle.iconUrl }}" alt="{{ vehicle.VehicleName | default: vehicle.Name }}" loading="lazy">
							{% endif %}
						</td>
						<td class="vehicle-type">{{ vehicle.assetType }}</td>
						<td class="vehicle-id">{{ vehicle.ID }}</td>
						<td class="vehicle-name">
							{% if vehicle_url %}
								<a href="https://restoremonarchy.com{{ vehicle_url }}" target="_blank" rel="noopener noreferrer">{{ vehicle.VehicleName | default: vehicle.Name }}</a>
							{% else %}
								{{ vehicle.VehicleName | default: vehicle.Name }}
							{% endif %}
						</td>
						<td class="vehicle-buy">{{ vehicle_buy | round: 0 }}</td>
					</tr>
				{% endfor %}
			{% else %}
				<tr>
					<td class="icon-cell"></td>
					<td class="vehicle-type"></td>
					<td class="vehicle-id"></td>
					<td class="vehicle-name">No vehicles available</td>
					<td class="vehicle-buy"></td>
				</tr>
			{% endif %}
		</tbody>
	</table>
</div>

<script>
	(function () {
		function loadListJs(onReady) {
			if (window.List) {
				onReady();
				return;
			}

			var script = document.createElement('script');
			script.src = 'https://cdn.jsdelivr.net/npm/list.js@2.3.1/dist/list.min.js';
			script.defer = true;
			script.onload = onReady;
			document.head.appendChild(script);
		}

		function createSortFunction(numericFields) {
			return function (a, b, options) {
				var valueName = options.valueName;
				var left = (a.values()[valueName] || '').toString().trim();
				var right = (b.values()[valueName] || '').toString().trim();

				if (numericFields.indexOf(valueName) !== -1) {
					var leftNumber = left === '' ? -Infinity : parseFloat(left);
					var rightNumber = right === '' ? -Infinity : parseFloat(right);
					if (leftNumber < rightNumber) return -1;
					if (leftNumber > rightNumber) return 1;
					return 0;
				}

				return left.localeCompare(right, undefined, { sensitivity: 'base', numeric: true });
			};
		}

		function init() {
			if (!window.List) return;

			new window.List('shop-items-list', {
				valueNames: ['item-type', 'item-id', 'item-name', 'item-buy', 'item-sell'],
				sortFunction: createSortFunction(['item-id', 'item-buy', 'item-sell'])
			});

			new window.List('shop-vehicles-list', {
				valueNames: ['vehicle-type', 'vehicle-id', 'vehicle-name', 'vehicle-buy'],
				sortFunction: createSortFunction(['vehicle-id', 'vehicle-buy'])
			});
		}

		if (document.readyState === 'loading') {
			document.addEventListener('DOMContentLoaded', function () {
				loadListJs(init);
			});
		} else {
			loadListJs(init);
		}
	})();
</script>