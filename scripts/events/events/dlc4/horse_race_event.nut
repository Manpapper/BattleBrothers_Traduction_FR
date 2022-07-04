this.horse_race_event <- this.inherit("scripts/events/event", {
	m = {
		Other = null,
		Fat = null,
		Athletic = null,
		Dumb = null,
		Reward = 0
	},
	function create()
	{
		this.m.ID = "event.horse_race";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 100.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{Vous rencontrez un homme qui tient les rênes d\'un cheval longiligne dont la crinière a connu des jours meilleurs. Le cheval a une barbe grise qui se forme, ses lèvres sèches réclament désespérément de l\'eau. En vous voyant, son propriétaire vous fait signe.%SPEECH_ON%Venez, venez! J\'ai un pari à proposer à ceux qui sont assez courageux et rapides pour penser qu\'ils vont le gagner!%SPEECH_OFF%Curieux, vous demandez quel est le pari. L\'homme tapote le cheval, un panache de poussière se soulève et vous pouvez voir l\'empreinte de sa main sur l\'épaule.%SPEECH_ON%Faites la course avec mon cheval! Pas avec un autre cheval bien sûr mais avec vos jambes! Si vous perdez, vous me donnez %reward% de couronnes. Si vous gagnez, je vous paierai le triple. Vous êtes partant?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Très bien. Que quelqu'un s\'avance et fasse cette course!",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Athletic != null)
				{
					this.Options.push({
						Text = "Notre homme le plus athlétique, %athlete%, va courir.",
						function getResult( _event )
						{
							return "C";
						}

					});
				}

				if (_event.m.Fat != null)
				{
					this.Options.push({
						Text = "Notre homme le plus gros, %fat%, va courir pour notre plaisir.",
						function getResult( _event )
						{
							return "D";
						}

					});
				}

				if (_event.m.Dumb != null)
				{
					this.Options.push({
						Text = "Je ne peux penser qu\'à %dumb% d\'être assez bête pour faire cette course.",
						function getResult( _event )
						{
							return "E";
						}

					});
				}

				this.Options.push({
					Text = "Non, merci.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "%terrainImage%{Vous désignez %randombrother% pour voir s\'il peut battre la bête. Les règles de la course sont d\'abord celles du pommier et avant même que vous ne puissiez commencer à encourager le vendeur, le cheval le fume complètement. Il arrive à la ligne d\'arrivée et commence à manger les pommes situées dans les branches. La compagnie reste totalement silencieuse, mais lorsque %randombrother% franchit la ligne d\'arrivée loin derrière le cheval, ils hurlent de joie comme s\'il venait de gagner les clés du meilleur bordel du royaume. Le propriétaire du cheval rit.%SPEECH_ON%Ne soyez pas dur avec vous-même, gentil monsieur. Le hasard fait partie du plaisir.%SPEECH_OFF%En effet, il semble que le spectacle offert ait amusé la compagnie.} ",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C\'était très amusant.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Other.getImagePath());
				this.World.Assets.addMoney(-_event.m.Reward);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous perdez  [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.Reward + "[/color] Couronnes"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Other.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 40)
					{
						bro.improveMood(1.0, "Felt entertained by " + _event.m.Other.getName() + " racing a horse");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "%terrainImage%{%athlete% s\'avance. Il saut sur place et s\'échauffe les épaules.%SPEECH_ON%Ouais, je vais faire la course avec ce pauvre cheval.%SPEECH_OFF%Le pari est fait et le propriétaire du cheval vous indique un chemin. Une fois la course mise en place, il brandit une paire de pinces en bois munie de quelques dents. Les pinces s\'entrechoquent lorsqu\'il coupe la corde et la course commence. Bien qu\'il ait l\'air d\'une verrue laissée sous la pluie, le cheval prend instantanément de vitesse l\'agile mercenaire. Ce n\'est qu\'à mi-parcours que l\'endurance du mercenaire semble le remettre dans la course, mais il échoue finalement sur la ligne d\'arrivée. Le propriétaire tape dans ses mains.%SPEECH_ON%Oh, on l\'a échappé belle! La course la plus serrée que j\'ai vu!%SPEECH_OFF%Vous acquiescez et payez à l\'homme ce qui lui est dû. %athlete% a été battu, mais malgré cela, il semble que la défaite l\'ait grandi à certains égard. La compagnie a certainement appréciée le spectacle.}",
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
				this.Characters.push(_event.m.Athletic.getImagePath());
				this.World.Assets.addMoney(-_event.m.Reward);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous perdez  [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.Reward + "[/color] Couronnes"
				});
				_event.m.Athletic.getBaseProperties().Stamina += 1;
				_event.m.Athletic.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/fatigue.png",
					text = _event.m.Athletic.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] de Fatigue Maximum"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Athletic.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 33)
					{
						bro.improveMood(1.0, "Felt entertained by " + _event.m.Athletic.getName() + " racing a horse");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "%terrainImage%{Se sentant plutôt audacieux, vous nommez l\'homme le plus gros de la compagnie pour effectuer la course. %fat% s\'avance, un sourcil levé, et vous demande si vous êtes sûr de vouloir le prendre comme champion de courses hippiques. Vous lui mettez la main sur l\'épaule et lui dites que c\'est le plus gros tas de graisse que vous ayez jamais vu en tant que mercenaire, mais que vous croyez en lui. Vous pensez également que la bête est un cheval de trait qui est sur le point de mourir, mais vous gardez cette réflexion pour vous.\n\n L\'homme et le cheval sont placés l\'un à côté de l\'autre. Un pommier se trouve au loin et le premier à l\'atteindre est le gagnant. Une fois les règles établies, la course est lancée. Ce n\'est pas un épreuve très longue. %fat% se laisse distancer presque instantanément et descend la piste en trombe, le visage rouge et le souffle court, les hommes sont presque morts de rire devant ce spectacle. Le mercenaire obèse et le cheval sinistre se retrouvent au pommier et y partagent le fruit de leur labeur. Vous payez au propriétaire du cheval ce qui lui est dû. Il sourit en comptant les pièces.%SPEECH_ON%D\'habitude, on n\'a pas ce genre de spectacle avec la course, monsieur.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Perdez quelques kilos, voulez-vous?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Fat.getImagePath());
				this.World.Assets.addMoney(-_event.m.Reward);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous perdez  [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.Reward + "[/color] Couronnes"
				});
				_event.m.Fat.getBaseProperties().Bravery += 1;
				_event.m.Fat.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Fat.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] Resolve"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Fat.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 33)
					{
						bro.improveMood(1.0, "Felt entertained by " + _event.m.Fat.getName() + " racing a horse");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "%terrainImage%{Vous choisissez %dumb%, le plus grand idiot de la compagnie, pour être votre champion dans cette course. Le propriétaire du cheval jette un coup d\'œil à l\'homme et lève un sourcil.%SPEECH_ON%Bien. Très bien.%SPEECH_OFF%Les règles de la course sont claires : le premier à atteindre le pommier éloigné est le vainqueur. L\'homme et l\'animal s\'alignent sur la piste. Prétendant qu\'il sait ce qu\'il fait, %dumb% s\'accroupit dans une position à trois pointes. Le propriétaire du cheval hurle et tape sa bête sur les fesses. %dumb% réalise une belle foulée et prend de l\'avance sur le cheval, mais il ne peut pas contrôler sa vitesse et entre en collision avec la bête. Le cheval plie les genoux et se renverse, tandis que %dumb% se retrouve dans la courbe de ses reins et est catapulté dans les airs lorsque la bête se retourne. C\'est un sacré spectacle que vous ne reverrez sûrement jamais. Le cheval se remet sur ses jambes et regarde autour de lui, confus, tandis que le corps inconscient de %dumb% s\'envole au-dessus de la ligne d\'arrivée. Vous tournez vos paumes vers le propriétaire du cheval dont les mains enserrent sa tête.%SPEECH_ON%Par les anciens dieux, homme, n\'êtes-vous pas inquiet pour votre mercenaire?%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ça va aller. Payez.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dumb.getImagePath());
				this.World.Assets.addMoney(_event.m.Reward * 3);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_money.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]" + _event.m.Reward * 3 + "[/color] Couronnes"
				});
				local injury = _event.m.Dumb.addInjury(this.Const.Injury.Concussion);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Dumb.getName() + " souffre de " + injury.getNameOnly()
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.World.Assets.getMoney() < 1000)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_fat = [];
		local candidates_athletic = [];
		local candidates_dumb = [];
		local candidates_other = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getSkills().hasSkill("trait.fat"))
			{
				candidates_fat.push(bro);
			}
			else if (bro.getSkills().hasSkill("trait.athletic"))
			{
				candidates_athletic.push(bro);
			}
			else if (bro.getSkills().hasSkill("trait.dumb") && !bro.getSkills().hasSkill("injury.severe_concussion"))
			{
				candidates_dumb.push(bro);
			}
			else
			{
				candidates_other.push(bro);
			}
		}

		if (candidates_other.len() == 0)
		{
			return;
		}

		this.m.Other = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];

		if (candidates_fat.len() != 0)
		{
			this.m.Fat = candidates_fat[this.Math.rand(0, candidates_fat.len() - 1)];
		}

		if (candidates_athletic.len() != 0)
		{
			this.m.Athletic = candidates_athletic[this.Math.rand(0, candidates_athletic.len() - 1)];
		}

		if (candidates_dumb.len() != 0)
		{
			this.m.Dumb = candidates_dumb[this.Math.rand(0, candidates_dumb.len() - 1)];
		}

		this.m.Reward = this.Math.rand(3, 6) * 100;
		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"randombrother",
			this.m.Other.getNameOnly()
		]);
		_vars.push([
			"fat",
			this.m.Fat ? this.m.Fat.getNameOnly() : ""
		]);
		_vars.push([
			"athlete",
			this.m.Athletic ? this.m.Athletic.getNameOnly() : ""
		]);
		_vars.push([
			"dumb",
			this.m.Dumb ? this.m.Dumb.getNameOnly() : ""
		]);
		_vars.push([
			"reward",
			this.m.Reward
		]);
	}

	function onClear()
	{
		this.m.Other = null;
		this.m.Fat = null;
		this.m.Athletic = null;
		this.m.Dumb = null;
		this.m.Reward = 0;
	}

});

