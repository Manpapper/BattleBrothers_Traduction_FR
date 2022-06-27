this.kraken_cult_destroyed_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.kraken_cult_destroyed";
		this.m.Title = "Après le combat";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_105.png[/img]{Les tentacules envahissent le marais en une masse corrompue, si bien que vous n\'avez pas tué le kraken, mais plutôt anéanti l\'endroit même où il se réfugiait. Chaque vestige vermoulu est recouvert de mousse, une étendue de terre cultivable et propice à l\'éclosion des champignons que la femme manger à maintes reprises. Vous vous accroupissez à côté d\'un lot qui n\'a pas encore été récolté, enfonçant leur chapeau comme un chat sur un papillon de nuit sans ailes. Les champignons se dégonflent au toucher. %randombrother% les regarde.%SPEECH_ON%Un mycologue pourrait savoir ce que c\'est.%SPEECH_OFF%Vous acquiescez. Ouais. C\'est possible. Vous avancez, écrasant les champignons sous vos pieds et pataugeant entre les membres et les vêtements ensanglantés qui flottent le long du marais, les têtes sans visage des tentacules ont leurs gueules feuillues repliées les unes sur les autres, leurs langues pendent comme des fouets. Vous trouvez la femme nichée derrière un massif de kudzu, vous écartez les lianes comme un homme cherchant fortune. Elle vous regarde avec un sourire.%SPEECH_ON%L\'avez-vous entendu? Avez-vous entendu sa beauté?%SPEECH_OFF%En soupirant, vous lui dites que les champignons ont envahi son esprit, les champignons étaient probablement là pour une raison. Le kraken avait déjà étendu son influence sur elle avant qu\'il n\'arrive, il l\'a utilisé pour amener tout le monde ici. Souriant de plus belle, elle demande à nouveau si vous avez entendu sa beauté. Vous lui dites que vous l\'avez entendu mourir. Elle fronce les sourcils.%SPEECH_ON%Un cri de mort? C\'est ce que vous pensez? Oh mon, oh non. Étranger, c\'était un appel à l\'aide. Vous ne comprenez pas? Ça veut dire qu\'il y en a d\'autres dehors! Plus nombreux! Peut-être des centaines! Et maintenant ils sont réveillés! Maintenant ils sont tous réveillés!%SPEECH_OFF%Vous reculez et fermez le rideau de kudzu. %randombrother% vous dit que la compagnie a trouvé quelque chose. Pendant un moment, vous pensez à sauver cette femme, mais vous vous ravisez. Vous savez dans quelle situation elle se trouve et l\'a laissez tranquille.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Très bien, montrez-moi ce qui a été trouvé.",
					function getResult( _event )
					{
						if (this.World.Flags.get("IsWaterWheelVisited"))
						{
							return "C";
						}
						else
						{
							return "B";
						}
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_105.png[/img]{La créature était presque trop grande pour mourir étendue sur le côté, au lieu de cela, elle s'incline vers l'avant avec son horrible bouche béante comme une explosion dans un rempart. Un mercenaire est assis les jambes croisées au sommet du kraken, comme un moine en pleine méditation. Une autre commence à piquer la créature dans les yeux jusqu'à ce que l'un d'eux s'ouvre et que les coins de l'orbite aspirent le liquide dans un gargarisme écumeux. Vous demandez aux mercenaires ce qui a été trouvé d'important et l'un d'eux vous fait signe de vous rendre devant la gueule de la créature. Avec les gencives relâchées, les dents pendent maintenant vers le bas, c'est une tour d'horreur que vous voyez. La rangée de lames de rasoirs est entrecoupée de vêtements et de morceaux de chairs. Vous apercevez aussi des membres entiers. Et la lame aussi.\n\n Vous mettez la main dans sa bouche, retirez la lame et l'essuyez avec un chiffon. En tournant la lame, vous apercevez des glyphes avec des chiffres à côté, une lame forgée en un temps et un lieu précis. L'acier est si éclatant qu'il semble avoir été façonné par la lumière des étoiles elles-mêmes. Malheureusement, la lame n'a pas de manche. La magnificence de la lame suggère qu'elle ne peut être adaptée à une simple poignée. En rangeant la lame dans l'inventaire, tu dis aux hommes de récupérer ce qu'ils peuvent sur la \"Bête des Bêtes\" et de se préparer à quitter cet endroit misérable.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous l\'avons emporté.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.getStash().makeEmptySlots(1);
				local item = this.new("scripts/items/special/legendary_sword_blade_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_105.png[/img]{La créature était presque trop grande pour mourir étendue sur le côté, au lieu de cela, elle s\'incline vers l\'avant avec son horrible bouche béante comme une explosion dans un rempart. Un mercenaire est assis les jambes croisées au sommet du kraken, comme un moine en pleine méditation. Une autre commence à piquer la créature dans les yeux jusqu\'à ce que l\'un d\'eux s\'ouvre et que les coins de l\'orbite aspirent le liquide dans un gargarisme écumeux. Vous demandez aux mercenaires ce qui a été trouvé d\'important et l\'un d\'eux vous fait signe de vous rendre devant la gueule de la créature. Avec les gencives relâchées, les dents pendent maintenant vers le bas, c\'est une tour d\'horreur que vous voyez. La rangée de lames de rasoirs est entrecoupée de vêtements et de morceaux de chairs.Vous apercevez aussi des membres entiers. Et la lame aussi.\n\n Vous mettez la main dans sa bouche, retirez la lame et l\'essuyez avec un chiffon. En tournant la lame, vous apercevez des glyphes avec des chiffres à côté, une lame forgée en un temps et un lieu précis. L\'acier est si éclatant qu\'il semble avoir été façonné par la lumière des étoiles elles-mêmes.Malheureusement, elle n\'a pas de poignée et vous faites immédiatement le rapprochement: une lame d\'une magnificence inouïe sans poignée et un vieil homme étrange dans une timonerie isolée possédant une poignée sans lame. Vous pensez savoir où l\'emmener. Vous la mettez dans l\'inventaire et ordonnez à la compagnie de piller tout ce qui vaut la peine d\'être pris, y compris de la soi-disante \"bête des bêtes\".}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous l\'avons emporté",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.getStash().makeEmptySlots(1);
				local item = this.new("scripts/items/special/legendary_sword_blade_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
	}

	function onPrepare()
	{
		this.World.Flags.set("IsKrakenDefeated", true);
	}

	function onPrepareVariables( _vars )
	{
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
	}

});

