this.adopt_wardog_event <- this.inherit("scripts/events/event", {
	m = {
		Bro = null,
		Houndmaster = null
	},
	function create()
	{
		this.m.ID = "event.adopt_wardog";
		this.m.Title = "Sur le chemin...";
		this.m.Cooldown = 120.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_27.png[/img]Vous avez remarqué le cabot quelques kilomètres de distance, que ce soit à l\'avant ou à l\'arrière, il est toujours là, à rentrer et sortir de votre champ de vision.\n\nUn cabot comme ça, ne suis pas un groupe de dangereuses personnes sans raisons - peut-être que quelqu\'un le nourrit?",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Chassez moi ce cabot de là!",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Plutôt le tuer maintenant avant qu\'il ne commence à venir voler dans nos provisions plus tard.",
					function getResult( _event )
					{
						local r = this.Math.rand(1, 100);

						if (r <= 60)
						{
							return "C";
						}
						else
						{
							return "D";
						}
					}

				},
				{
					Text = "La compagnie a besoin d\'une mascotte. Prenons-le.",
					function getResult( _event )
					{
						local r = this.Math.rand(1, 100);

						if (r <= 75)
						{
							return "E";
						}
						else
						{
							return "F";
						}
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Houndmaster != null)
				{
					this.Options.push({
						Text = "%houndmaster%, tu es entraîné pour gérer les chiens, n\'est-ce pas?",
						function getResult( _event )
						{
							return "G";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_75.png[/img]Ce n\'est pas un endroit pour un chiot. La prochaine fois que le chien apparaît, vous lui lancé un caillou bien placé entre les deux yeux. Le chien fuit en glapissant. Il s\'arrête, peut-être pensant qu\'il s\'agissait d\'une erreur, mais vous le corrigez rapidement avec un deuxième caillou. Le chien part pour ne plus jamais être revu.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Et ne revient jamais!",
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
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_75.png[/img]Vous prenez un arc et encochez une flèche. Plusieurs de vos frère d\'arme vous regardent pendant que vous visez. Le tir passe à côté, mais le chien a bien compris le message et s\'en va rapidement.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je voulais juste lui faire peur.",
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
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_27.png[/img]Vous prenez un arc et encochez une flèche. Plusieurs de vos frère d\'arme vous regardent pendant que vous visez. le vent vient, s\'arrête, puis revient. Vous attendez patiemment avant de tirer la corde et fermer un oeil et viser le chien. Il s\'arrête et vous regarde entre temps long halètement.\n\nVous relâchez le tir. La flèche traverse l\'air et le chien hurle de douleur. Il se redresse sur ses pattes arrière et tombe, ses pattes frappant et raclant le sol jusqu\'à ce qu\'elles s\'arrêtent.Vous rangez l\'arc et la compagnie reprend la route.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Le pauvre.",
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
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_27.png[/img]Vous décidez de prendre un morceau de viand et de la tendre en approchant le chien. Il est craintif au début, il recule à votre approche, mais le doût arôme dans votre main est séduisante c\'est sûr. Le bâtard revient vers vous, s\'arrêtant ici et là, les yeux à la recherche d\'une embuscade.\n\nVous pouvez voir les côtes du chien , plusieurs jours sur la route ont donné un air squelettique au chien. Ses oreilles sont recousues et sa queue est marqué de signes de bataille. Cet animal sait comment se battre et c\'est exactement ce qu\'il va faire pour vous maintenant, ce battre.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bienvenue dans la compagnie.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/accessory/wardog_item");
				item.m.Name = "Battle Brother";
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_37.png[/img]Un chien robuste comme lui ferait une excellente mascotte. Le petit cabot pourra certainement booster le moral. Vous ordonnez %bro% de le nourrir dans l\'espoir qu\'il decide de rester. Il part avec un morceau de restes et s\'accroupit.%SPEECH_ON%Bon chien.%SPEECH_OFF%Le cabot renifle la nourriture, puis la dévore - et la main du mercenaire avec. Votre frère d\'arme daute en arrière, blottissant son bras dans sa poitrine comme s\'il risquait de le perdre. Le chien, quant à lui, avale les morceaux et s\'enfuit.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Dommage, Il aurait vraiment eu sa place parmi nous.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Bro.getImagePath());
				local injury = _event.m.Bro.addInjury(this.Const.Injury.FeedDog);
				this.List = [
					{
						id = 10,
						icon = injury.getIcon(),
						text = _event.m.Bro.getName() + " souffre de " + injury.getNameOnly()
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "G",
			Text = "[img]gfx/ui/events/event_27.png[/img]Vous demandez %houndmaster% le maître chien s\'il peut essayer et \'charmer\' le chien. Il hôche de la tête et s\'avance vers le chien. Les oreilles du cabot sauvage passent de couchés à relevés. Accroupi, le maître chien se rapproche doucement de la bête. Il garde sa main en avant avec un morceau de viande. La faim l\'emporte sur la vigilance et le chien se rapproche de la main du maître chien. Le chien l\'enlève avec la langue de sa paume et la dévore. Le dresseur de chiens lui donne une autre bouchée. Il le caresse et trouve l\'endroit idéal derrière ses oreilles. En regardant derrière, %houndmaster% hôche la tête.%SPEECH_ON%Oui, c\'est une bonne bête et elle sera facilement entrainable.%SPEECH_OFF%C\'est super. Vous demandez s\'il pourra se battre. Le maître chien se pince les lèvres.%SPEECH_ON%Les chiens, c\'est comme les hommes. S\'il respire, il peut se battre.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Super.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Houndmaster.getImagePath());
				local item = this.new("scripts/items/accessory/wardog_item");
				item.m.Name = "Battle Brother";
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type == this.Const.World.TerrainType.Forest || currentTile.Type == this.Const.World.TerrainType.Snow || currentTile.Type == this.Const.World.TerrainType.LeaveForest || currentTile.Type == this.Const.World.TerrainType.Mountains)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.houndmaster")
			{
				candidates.push(bro);
			}
		}

		this.m.Bro = brothers[this.Math.rand(0, brothers.len() - 1)];

		if (candidates.len() != 0)
		{
			this.m.Houndmaster = candidates[this.Math.rand(0, candidates.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"bro",
			this.m.Bro.getName()
		]);
		_vars.push([
			"houndmaster",
			this.m.Houndmaster != null ? this.m.Houndmaster.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Bro = null;
		this.m.Houndmaster = null;
	}

});

