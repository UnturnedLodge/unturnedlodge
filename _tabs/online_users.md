---
icon: fa-solid fa-users
order: 5
title: Online Users
---

<div id="online-users-app" class="mt-3">
	<p class="text-muted mb-3" id="ou-window">Loading time window...</p>

	<div id="ou-loading" class="alert alert-info" role="status">
		Loading online users...
	</div>

	<div id="ou-error" class="alert alert-danger d-none" role="alert"></div>

	<div class="table-responsive d-none" id="ou-table-wrap">
		<table class="table table-striped align-middle" id="ou-table">
			<thead>
				<tr>
					<th scope="col" style="width: 5rem;">#</th>
					<th scope="col">Player</th>
					<th scope="col" style="width: 9rem;">Time</th>
				</tr>
			</thead>
			<tbody></tbody>
		</table>
	</div>

	<p id="ou-empty" class="text-muted d-none mb-0">No players currently connected.</p>
</div>

<script>
	(function () {
		'use strict';

		var SERVER_ID = '38816940';
		var WINDOW_MINUTES = 30;
		var API_BASE = 'https://api.battlemetrics.com/servers/' + SERVER_ID + '/relationships/sessions';

		var loadingEl = document.getElementById('ou-loading');
		var errorEl = document.getElementById('ou-error');
		var emptyEl = document.getElementById('ou-empty');
		var tableWrapEl = document.getElementById('ou-table-wrap');
		var tbodyEl = document.querySelector('#ou-table tbody');
		var windowEl = document.getElementById('ou-window');

		function pad2(value) {
			return String(value).padStart(2, '0');
		}

		function formatDuration(ms) {
			var totalSeconds = Math.max(0, Math.floor(ms / 1000));
			var hours = Math.floor(totalSeconds / 3600);
			var minutes = Math.floor((totalSeconds % 3600) / 60);
			var seconds = totalSeconds % 60;
			return pad2(hours) + ':' + pad2(minutes) + ':' + pad2(seconds);
		}

		function getSessionName(session) {
			var attrs = session && session.attributes ? session.attributes : {};
			return attrs.name || attrs.playerName || attrs.player || 'Unknown';
		}

		function isConnected(session) {
			var attrs = session && session.attributes ? session.attributes : {};
			return attrs.stop === null;
		}

		function getStartDate(session) {
			var attrs = session && session.attributes ? session.attributes : {};
			return attrs.start ? new Date(attrs.start) : null;
		}

		function setError(message) {
			errorEl.textContent = message;
			errorEl.classList.remove('d-none');
		}

		function clearStatus() {
			loadingEl.classList.add('d-none');
			errorEl.classList.add('d-none');
			emptyEl.classList.add('d-none');
			tableWrapEl.classList.add('d-none');
		}

		function renderRows(rows, now) {
			tbodyEl.innerHTML = '';

			if (!rows.length) {
				emptyEl.classList.remove('d-none');
				return;
			}

			rows.forEach(function (row, index) {
				var tr = document.createElement('tr');

				var tdIndex = document.createElement('td');
				tdIndex.textContent = String(index + 1);

				var tdPlayer = document.createElement('td');
				tdPlayer.textContent = row.name;

				var tdTime = document.createElement('td');
				tdTime.textContent = formatDuration(now - row.start.getTime());

				tr.appendChild(tdIndex);
				tr.appendChild(tdPlayer);
				tr.appendChild(tdTime);
				tbodyEl.appendChild(tr);
			});

			tableWrapEl.classList.remove('d-none');
		}

		function computeWindow() {
			var stop = new Date();
			var start = new Date(stop.getTime() - WINDOW_MINUTES * 60 * 1000);
			return { start: start, stop: stop };
		}

		function getApiUrl(win) {
			return (
				API_BASE +
				'?start=' + encodeURIComponent(win.start.toISOString()) +
				'&stop=' + encodeURIComponent(win.stop.toISOString())
			);
		}

		function renderWindow(win) {
			windowEl.textContent =
				'Window (UTC): ' + win.start.toISOString() + ' -> ' + win.stop.toISOString();
		}

		function load() {
			clearStatus();
			loadingEl.classList.remove('d-none');

			var now = new Date();
			var win = computeWindow();
			renderWindow(win);

			fetch(getApiUrl(win), { method: 'GET' })
				.then(function (response) {
					if (!response.ok) {
						throw new Error('HTTP ' + response.status + ' while loading sessions.');
					}
					return response.json();
				})
				.then(function (payload) {
					var list = Array.isArray(payload && payload.data) ? payload.data : [];
					var connected = list
						.filter(isConnected)
						.map(function (session) {
							return {
								name: getSessionName(session),
								start: getStartDate(session)
							};
						})
						.filter(function (row) {
							return row.start instanceof Date && !Number.isNaN(row.start.getTime());
						});

					clearStatus();
					renderRows(connected, now);
				})
				.catch(function (error) {
					clearStatus();
					setError(error.message || 'Unable to load online users.');
				});
		}

		load();
	})();
</script>

