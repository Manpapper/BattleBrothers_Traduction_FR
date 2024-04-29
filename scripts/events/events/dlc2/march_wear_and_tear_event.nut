this.march_wear_and_tear_event <- this.inherit("scripts/events/event", {
	m = {
		Tailor = null,
		Other = null,
		Vagabond = null,
		Thief = null
	},
	function create()
	{
		this.m.ID = "event.march_wear_and_tear";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 50.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{Marcher sans arrêt de par le monde a mis les hommes à rude épreuve. Chaque fois qu\'un mercenaire enlève une botte, on peut voir le sang suinter à travers sa chaussette. Ils ont accumulé des plaies et des furoncles. Un homme s\'arrache la chair de son orteil et dit qu\'il regrette de l\'avoir fait, vous acquiescez. Tout compte fait, c\'est le prix à payer pour être si souvent sur la route.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Faites-vous à l\'idée.",
					function getResult( _event )
					{
						return "End";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Tailor != null)
				{
					this.Options.push({
						Text = "Peut-être qu\'on peut créer de nouvelles tenues avec ce qu\'on a?",
						function getResult( _event )
						{
							return "Tailor";
						}

					});
				}

				if (_event.m.Vagabond != null)
				{
					this.Options.push({
						Text = "Vous avez parcouru le monde, %travelbro%. Des suggestions?",
						function getResult( _event )
						{
							return "Vagabond";
						}

					});
				}

				if (_event.m.Thief != null)
				{
					this.Options.push({
						Text = "Attends. %streetrat%, on dirait que tu as quelque chose à dire?",
						function getResult( _event )
						{
							return "Thief";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "End",
			Text = "%terrainImage%{Le prochain arrêt n\'est pas loin. Vous espérez que les hommes pourront tenir le coup jusqu\'à ce qu\'ils y arrivent. Les bandages que vous avez seront appliqués si nécessaire.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Remettez vos bottes.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.vagabond" || bro.getBackground().getID() == "background.refugee" || bro.getBackground().getID() == "background.messenger")
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 25)
					{
						bro.addLightInjury();
						this.List.push({
							id = 10,
							icon = "ui/icons/days_wounded.png",
							text = bro.getName() + " souffre de blessures légères"
						});
					}
				}

				local amount = brothers.len();
				this.World.Assets.addMedicine(-amount);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_medicine.png",
					text = "Vous perdez  [color=" + this.Const.UI.Color.NegativeEventValue + "]-" + montant + "[/color] Fournitures médicales."
				});
			}

		});
		this.m.Screens.push({
			ID = "Tailor",
			Text = "%terrainImage%{%tailor% le tailleur se frotte le menton avec deux doigts. Il les pointe finalement vers l\'avant.%SPEECH_ON%Messieurs, donnez-moi chaque morceau de vêtement inutilisé ou déglingué que vous avez. Chaque article que vous avez. Donnez-les moi. Voilà. Oui, c\'est absolument dégoûtant, %otherbrother%. Votre chemise préférée? Par les dieux, donnez-le-moi. Merci.%SPEECH_OFF%Le tailleur ramasse des piles de vêtements usagés et se met au travail avec ses ciseaux. Il coupe, découpe et fait des pauses. Il fait beaucoup de pauses, toujours incertain de son travail. Mais finalement, il présente les résultats. Une pile de chaussettes neuves et assez de restes pour fournir quelques bandages supplémentaires. Il porte également un nouveau vêtement très flashy qu\'il a crée on ne sait comment.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C\'est un magicien si j\'en ai jamais vu un.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Tailor.getImagePath());
				_event.m.Tailor.improveMood(1.0, "Fashioned himself something nice from cloth scraps");

				if (_event.m.Tailor.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Tailor.getMoodState()],
						text = _event.m.Tailor.getName() + this.Const.MoodStateEvent[_event.m.Tailor.getMoodState()]
					});
				}

				local brothers = this.World.getPlayerRoster().getAll();
				local amount = brothers.len();
				this.World.Assets.addMedicine(amount);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_medicine.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + amount + "[/color] Medical Supplies."
				});
			}

		});
		this.m.Screens.push({
			ID = "Vagabond",
			Text = "%terrainImage%{Quand il s\'agit de marcher, %travelbro% a une grande gueule. Il se moque de la détresse de ses compagnons mercenaires.%SPEECH_ON%Ah, maintenant c\'est de ça que je parle ! Ne vous souciez pas de la douleur, les gars, embrassez la douleur!%SPEECH_OFF%La compagnie lui dit collectivement de se la fermer, mais le vagabond remue joyeusement ses orteils. Vous n\'aviez même pas réalisé qu\'il avait enlevé ses bottes avant cela, ses pieds sont tellement calleux que vous pensiez que les figures osseuses étaient des plis de cuir!}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Remettez vos foutues bottes.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Vagabond.getImagePath());
				_event.m.Vagabond.improveMood(1.0, "Enjoyed life on the road");

				if (_event.m.Vagabond.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Vagabond.getMoodState()],
						text = _event.m.Vagabond.getName() + this.Const.MoodStateEvent[_event.m.Vagabond.getMoodState()]
					});
				}

				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.vagabond" || bro.getBackground().getID() == "background.refugee" || bro.getBackground().getID() == "background.messenger")
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 25)
					{
						bro.addLightInjury();
						this.List.push({
							id = 10,
							icon = "ui/icons/days_wounded.png",
							text = bro.getName() + " suffers light wounds"
						});
					}
				}

				local amount = brothers.len();
				this.World.Assets.addMedicine(-amount);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_medicine.png",
					text = "Vous perdez  [color=" + this.Const.UI.Color.NegativeEventValue + "]-" + amount + "[/color] Medical Supplies."
				});
			}

		});
		this.m.Screens.push({
			ID = "Thief",
			Text = "%terrainImage%{%thief% Le voleur s\'approche de vous. Vous vous écartez et mettez vos mains dans vos poches, vous lui demandez ce qu\'il veut. Il sourit et répond.%SPEECH_ON%Bon, je vais être honnête avec vous, capitaine. La dernière fois que nous nous sommes arrêtés en ville, je me suis servi dans la boutique d\'un pacificateur aveugle. Quoi ? J\'avais une dent douloureuse. Aucune raison de payer pour réparer ce que les vieux dieux m\'ont donné. Bref, j\'ai réparé ma dent. Vous voyez ? Quel sourire, hein ? Mais ensuite, j\'ai senti des courbatures, mec, des courbatures partout ! Alors je suis retourné voir le pacificateur et...%SPEECH_OFF%Vous interrompez l\'homme et lui demandez combien il a volé. Il sort un sac de produits médicinaux. Il pose fièrement ses mains sur ses hanches et regarde le monde avec un sourire en coin.%SPEECH_ON%Il suffit de dire que je n\'ai plus mal.%SPEECH_OFF%} ",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Pourquoi se disputaient-ils déjà ?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Thief.getImagePath());
				local amount = this.Math.rand(5, 15);
				this.World.Assets.addMedicine(amount);
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_medicine.png",
					text = "Vous recevez [color=" + this.Const.UI.Color.PositiveEventValue + "]-" + amount + "[/color] Medical Supplies."
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(currentTile) <= 5)
			{
				return;
			}
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		if (this.World.Assets.getMedicine() < brothers.len())
		{
			return;
		}

		local candidates_tailor = [];
		local candidates_vagabond = [];
		local candidates_thief = [];
		local candidates_other = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.tailor")
			{
				candidates_tailor.push(bro);
			}
			else
			{
				candidates_other.push(bro);

				if (bro.getBackground().getID() == "background.thief")
				{
					candidates_thief.push(bro);
				}
				else if (bro.getBackground().getID() == "background.vagabond" || bro.getBackground().getID() == "background.refugee" || bro.getBackground().getID() == "background.messenger")
				{
					candidates_vagabond.push(bro);
				}
			}
		}

		if (candidates_tailor.len() != 0 && candidates_other.len() != 0)
		{
			this.m.Tailor = candidates_tailor[this.Math.rand(0, candidates_tailor.len() - 1)];
			this.m.Other = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];
		}

		if (candidates_vagabond.len() != 0)
		{
			this.m.Vagabond = candidates_vagabond[this.Math.rand(0, candidates_vagabond.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"tailor",
			this.m.Tailor != null ? this.m.Tailor.getName() : ""
		]);
		_vars.push([
			"otherbrother",
			this.m.Other != null ? this.m.Other.getName() : ""
		]);
		_vars.push([
			"travelbro",
			this.m.Vagabond != null ? this.m.Vagabond.getName() : ""
		]);
		_vars.push([
			"thief",
			this.m.Thief != null ? this.m.Thief.getName() : ""
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Tailor = null;
		this.m.Other = null;
		this.m.Vagabond = null;
		this.m.Thief = null;
	}

});

