this.vulcano_enter_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.vulcano_enter";
		this.m.Title = "As you approach...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_151.png[/img]{La fin de l\'empire. La métropole des cendres. L\'Annihilation. Quel que soit son nom, l\'ancienne cité n\'est plus qu\'une vaste ruine grise. Elle se trouve sous une montagne dont le sommet a disparu, sa forme autrefois glorieuse ayant été anéantie par une énorme éruption. L\'explosion a frappé avec une telle violence que des ondes de choc ont déferlé sur les rues pavées et envoyé les briques en pluie sur la ville elle-même. D\'énormes rochers granitiques cratérisèrent des quartiers entiers et des débris bouillants vaporisèrent tout sur leur passage. La coulée de lave est arrivée en dernier, recouvrant une grande partie de la ville d\'une boue noire, dont les bords ont pris des contours bulbeux jusqu\'à donner l\'impression qu\'un nuage de fumée noire s\'était solidifié. C\'est un spectacle horrible à voir, en partie parce que la rage de la terre a également capturé de nombreuses victimes à perpétuité : des moulages gris d\'humains antiques sont encore visibles aujourd\'hui, posés de manière très vivante, comme des couples se serrant la main, l\'un regardant au-dessus d\'un poêle, un autre caressant un chien. Bien sûr, il est tout à fait dans la nature de l\'homme de voir de telles reliques de destruction et, aussi éloignés qu\'ils soient de la réalité, d\'affluer vers ses vestiges, et de revivre la violence par procuration par le biais de la foi. Les adeptes du doreur y voient un avertissement pour ne pas tomber dans la prodigalité et la cupidité. Les habitants du Nord y voient un affrontement entre de vieux dieux, une rareté depuis l\'aube de l\'humanité. Que ce soit l\'une ou l\'autre foi, les deux résident ici dans un respect mutuel pour ceux dont les vies ont été perdues... respectueux pour le moment, du moins.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Notre destin nous conduira à nouveau ici en temps voulu.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}

		});
	}

	function onUpdateScore()
	{
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

