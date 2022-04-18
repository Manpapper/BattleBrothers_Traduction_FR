this.dried_oasis_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null,
		Slayer = null
	},
	function create()
	{
		this.m.ID = "event.dried_oasis";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 120.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{Le désert est si semblable que la vue d'un peu de verdure attire immédiatement le regard. Tel est le magnétisme d'une oasis. Vous l'apercevez de loin, et en vous approchant, vous réalisez que le vert n'est pas du tout un arbre, mais une bannière qui s'envole de la prise d'un arbre mort et séché. Autour de lui, il y a d'autres arbres morts, dont certains se sont écrasés dans les sables qui les rongent de toutes parts. Et au milieu de cette oasis disparue se trouve un squelette, la tête en bas, dans une petite cuvette de terre où, peut-être, il y avait de l'eau autrefois. À côté du squelette se trouve un tas de trésors. Toutes les couronnes du monde, mais pas une seule goutte d'eau pour les dépenser. Tu te diriges vers l'or, mais les pièces bougent avec toi, s'écartant les unes des autres tandis qu'un serpent noir s'élève et te siffle dessus. Du poisons verts s'écoulent de ses crocs.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [],
			function start( _event )
			{
				this.Options.push({
					Text = "Que quelqu'un aille le chercher !",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				});

				if (_event.m.Slayer != null)
				{
					this.Options.push({
						Text = "%beastslayer% peut gérer ce petit monstre.",
						function getResult( _event )
						{
							return "D";
						}

					});
				}

				this.Options.push({
					Text = "Cela ne vaut pas la peine de s'inquiéter.",
					function getResult( _event )
					{
						return "E";
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "%terrainImage%{%brother% s'avance avec son arme à la main. Le serpent se cabre et l'homme le transperce de part en part, tuant instantanément la créature. Il la tient au bout de son acier, faisant frétiller sa chair avant de la jeter de côté.%SPEECH_ON%Paiement le plus facile que j'ai jamais eu.%SPEECH_OFF%Il dit alors que le trésor est pris dans l'inventaire de la compagnie.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bien joué.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
				local money = this.Math.rand(100, 300);
				this.World.Assets.addMoney(money);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Couronnes"
					}
				];
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "%terrainImage%{%brother% s'avance avec son arme à la main. Le serpent se cabre, l'homme rit et attaque avec son arme. Le serpent contourne habilement l'acier et frappe le long de l'arbre, entaillant l'homme au niveau des articulations. En hurlant, il tombe à la renverse, les hommes le ramassent et le traînent. Bientôt, il est pris de convulsions et d'écume et toute sa main se bombe et crache du pus. Vous pensez qu'il survivra, mais il faudra beaucoup de temps avant qu'il ne soit prêt à se battre à nouveau. Quant au trésor, il se déplace dans les sables et vous ne pouvez que le regarder glisser lentement dans la dune elle-même, comme un bateau qui s'enfonce dans l'eau. Lorsque vous vous penchez pour le voir partir, d'autres serpents noirs émergent comme pour vous avertir à qui il appartient : c'est le trésor du désert, maintenant et pour toujours.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bien essayé.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
				_event.m.Dude.addHeavyInjury();
				_event.m.Dude.worsenMood(1.5, "A été mordu par un serpent du désert");
				local injury = _event.m.Dude.addInjury([
					{
						ID = "injury.pierced_hand",
						Threshold = 0.25,
						Script = "injury/pierced_hand_injury"
					}
				]);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Dude.getName() + " souffre de " + injury.getNameOnly()
				});
				local effect = this.new("scripts/skills/injury/sickness_injury");
				_event.m.Dude.getSkills().add(effect);
				this.List.push({
					id = 11,
					icon = effect.getIcon(),
					text = _event.m.Dude.getName() + " is sick"
				});

				if (_event.m.Dude.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 12,
						icon = this.Const.MoodStateIcon[_event.m.Dude.getMoodState()],
						text = _event.m.Dude.getName() + this.Const.MoodStateEvent[_event.m.Dude.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "%terrainImage%{%beastslayer% regarde le serpent. Il hoche la tête comme s'il se souvenait d'une vieille leçon.%SPEECH_ON% On ne les voit que dans les dunes. Très venimeux. %SPEECH_OFF%Le serpent lui siffle dessus. L'homme acquiesce avant de tendre une main et d'attraper le serpent par la tête.%SPEECH_ON% Ton venin commence et finit dans ta bouche, petit, mais je peux l'utiliser partout. J'espère que tu comprendras le marché.%SPEECH_OFF%L'homme fait craquer la tête du serpent avant de la couper net avec une petite lame et il pince son doigt sur le cadavre filandreux du reptile. Il hoche à nouveau la tête. %SPEECH_ON%Je vais me servir du serpent, et je fais confiance à votre capitaine pour se servir du trésor.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Content que vous soyez là.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Slayer.getImagePath());
				local money = this.Math.rand(100, 300);
				this.World.Assets.addMoney(money);
				this.List = [
					{
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + money + "[/color] Couronnes"
					}
				];
				local item = this.new("scripts/items/accessory/antidote_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
				_event.m.Slayer.improveMood(1.0, "Applied his expertise on creatures");

				if (_event.m.Slayer.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Slayer.getMoodState()],
						text = _event.m.Slayer.getName() + this.Const.MoodStateEvent[_event.m.Slayer.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "%terrainImage%{Vous avez entendu parler de ces serpents qui tuent des hommes sur le champ. Avec cette menace sur la table, vous ne pensez pas que cela vaille la peine et vous laissez le trésor derrière vous.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "On passe à autre chose !",
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
		if (!this.Const.DLC.Desert)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (currentTile.Type != this.Const.World.TerrainType.Desert && currentTile.TacticalType != this.Const.World.TerrainTacticalType.DesertHills)
		{
			return;
		}

		if (currentTile.HasRoad)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(currentTile) <= 8)
			{
				return;
			}
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];
		local candidates_slayer = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.beast_slayer")
			{
				candidates_slayer.push(bro);
			}
			else
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Dude = candidates[this.Math.rand(0, candidates.len() - 1)];

		if (candidates_slayer.len() != 0)
		{
			this.m.Slayer = candidates_slayer[this.Math.rand(0, candidates_slayer.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"beastslayer",
			this.m.Slayer != null ? this.m.Slayer.getName() : ""
		]);
		_vars.push([
			"brother",
			this.m.Dude.getName()
		]);
	}

	function onClear()
	{
		this.m.Dude = null;
		this.m.Slayer = null;
	}

});

