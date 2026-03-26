const crypto = require('crypto');

function toBase64Url(buffer) {
	if (typeof buffer.toString === 'function') {
		try {
			return buffer.toString('base64url');
		} catch (_err) {
			return buffer
				.toString('base64')
				.replace(/\+/g, '-')
				.replace(/\//g, '_')
				.replace(/=+$/g, '');
		}
	}

	return '';
}

function generatePublicToken(bytes = 32) {
	return toBase64Url(crypto.randomBytes(bytes));
}

function hashToken(rawToken) {
	return crypto
		.createHash('sha256')
		.update(String(rawToken))
		.digest('hex');
}

module.exports = {
	generatePublicToken,
	hashToken,
};

