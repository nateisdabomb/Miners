// Copyright © 2012, Jakob Bornecrantz.  All rights reserved.
// See copyright notice in src/charge/charge.d (GPLv2 only).
module miners.ion.texture;

import lib.gl.gl;

import charge.charge;

import charge.game.gui.container;
import charge.game.gui.messagelog;

class DpcuTexture : private MessageLog
{
private:
	TextureContainer container;

	const width = 32;
	const height = 16;

	ushort vram[];

public:
	this(ushort *mem)
	{
		container = new TextureContainer(
			null, 0, 0, width * 8, height * (8 + 1));
		super(container, 0, 0, width, height, 1);

		foreach(int i, t; text) {
			text[i].length = width;
			foreach(int j, g; text[i])
				text[i][j] = cast(char)('a' + i + j);
		}

		vram = mem[0x8000 .. 0x8000 + 32 * 16];
	}

	void destruct()
	{
		container.breakApart();
	}

	GfxTexture texture()
	{
		return container.texture();
	}

	void paint()
	{
		repaint();

		for (int i; i < height; i++)
			for (int j; j < width; j++)
				text[i][j] = cast(char)(vram[j + i * width] & 0x007f);
		container.paint();
	}

protected:
	void paint(GfxDraw d)
	{
		if (glyphs is null)
			makeResources();

		int top;
		int bottom = top + rowHeight;
		int left;
		int right = left + 8;

		glDisable(GL_BLEND);
		glBegin(GL_QUADS);
		foreach (int i, c; vram) {
			int bg = (c & 0xf000) >> 12;

			glColor4fv(colors[bg].ptr);
			glVertex2i( left,    top);
			glVertex2i( left, bottom);
			glVertex2i(right, bottom);
			glVertex2i(right,    top);


			if (i % 32 == 31) {
				top += rowHeight;
				bottom += rowHeight;
				left = 0;
				right = left + 8;
			} else {
				left += 8;
				right = left + 8;
			}
		}
		glEnd();

		top = 1;
		bottom = top + 8;
		left = 0;
		right = left + 8;

		glEnable(GL_BLEND);
		glEnable(GL_TEXTURE_2D);
		glBindTexture(GL_TEXTURE_2D, glyphs.id);
		glBegin(GL_QUADS);
		foreach (int i, c; vram) {
			int fg = (c & 0x0f00) >>  8;
			int te = (c & 0x007f) >>  0;

			if (te != 0 && te != ' ') {
				float srcX1, srcX2;
				srcX1 =     te / 256f;
				srcX2 = (te+1) / 256f;

				glColor4fv(colors[fg].ptr);
				glTexCoord2f(srcX1,      0);
				glVertex2i(   left,    top);
				glTexCoord2f(srcX1,      1);
				glVertex2i(   left, bottom);
				glTexCoord2f(srcX2,      1);
				glVertex2i(  right, bottom);
				glTexCoord2f(srcX2,      0);
				glVertex2i(  right,    top);


			}
			if (i % 32 == 31) {
				top += rowHeight;
				bottom = top + 8;
				left = 0;
				right = left + 8;
			} else {
				left += 8;
				right = left + 8;
			}
		}
		glEnd();
		glBindTexture(GL_TEXTURE_2D, 0);
		glDisable(GL_TEXTURE_2D);
	}

	const Color4f colors[16] = [
		Color4f(0x00/255f, 0x00/255f, 0x00/255f, 1),
		Color4f(0x00/255f, 0x00/255f, 0xAA/255f, 1),
		Color4f(0x00/255f, 0xAA/255f, 0x00/255f, 1),
		Color4f(0x00/255f, 0xAA/255f, 0xAA/255f, 1),
		Color4f(0xAA/255f, 0x00/255f, 0x00/255f, 1),
		Color4f(0xAA/255f, 0x00/255f, 0xAA/255f, 1),
		Color4f(0xAA/255f, 0x55/255f, 0x00/255f, 1),
		Color4f(0xAA/255f, 0xAA/255f, 0xAA/255f, 1),
		Color4f(0x55/255f, 0x55/255f, 0x55/255f, 1),
		Color4f(0x55/255f, 0x55/255f, 0xFF/255f, 1),
		Color4f(0x55/255f, 0xFF/255f, 0x55/255f, 1),
		Color4f(0x55/255f, 0xFF/255f, 0xFF/255f, 1),
		Color4f(0xFF/255f, 0x55/255f, 0x55/255f, 1),
		Color4f(0xFF/255f, 0x55/255f, 0xFF/255f, 1),
		Color4f(0xFF/255f, 0xFF/255f, 0x55/255f, 1),
		Color4f(0xFF/255f, 0xFF/255f, 0xFF/255f, 1),
	];
}