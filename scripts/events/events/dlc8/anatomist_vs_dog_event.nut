this.anatomist_vs_dog_event <- this.inherit("scripts/events/event", {
	m = {
		Anatomist = null,
		Houndmaster = null
	},
	function create()
	{
		this.m.ID = "event.anatomist_vs_dog";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_27.png[/img]{%anatomist% l\'anatomiste vient vous voir avec une idée horrible: il veut prendre un des chiens de la compagnie et l\'ouvrir. Pour être sûr, vous lui demandez s\'il a l\'intention de tuer le chien. Il jette sa tête d\'un côté à l\'autre, comme pour peser les options.%SPEECH_ON%Je crois que du point de vue canin, il serait préférable qu\'il ait arrêté de respirer avant que nous le disséquions.%SPEECH_OFF%L\'anatomiste explique que l\'utilisation de chiens pour des études n\'est pas inhabituelle, et que cette exigence servira à mieux comprendre les loups-garous, auxquels un chien est sans doute apparenté. Vous ne pouvez pas imaginer que le massacre d\'un chien de la compagnie sera bien accueilli par le reste des hommes et vous lui dites de trouver un des chiens galeux qui traine un peu partout. Il secoue la tête.%SPEECH_ON%Tous les chiens sont presque certainement des cousins du loup-garou, mais un chien de combat est d\'une race différente, et très certainement le plus proche de la question au fond.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ok, faites-le.",
					function getResult( _event )
					{
						if (_event.m.Houndmaster != null)
						{
							return "E";
						}
						else if (this.Math.rand(1, 100) <= 50)
						{
							return "B";
						}
						else
						{
							return "C";
						}
					}

				},
				{
					Text = "Non, je ne pense pas.",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_37.png[/img]{Vous acquiescez et dites à l\'homme de faire ce qu\'il doit être fait. En ce qui vous concerne, vous êtes ici pour aider ces anatomistes à faire leur travail, et parfois cela peut signifier qu\'il faut donner un peu de soi-même. Dans ce cas, un chien de combat en est le digne représentant. %anatomist% est content et se met à l\'ouvrage. Vous entendez le tintement du collier du chien, suivi d\'un bref jappement. Vous faites la sourde oreille aux sons qui suivent.\n\n%anatomist% finit par réapparaître, les mains ensanglantées. Il acquiesce et dit que le spécimen était satisfaisant et que beaucoup de choses ont été apprises grâce à sa race. Vous lui dites d\'enterrer le chien. Il a l\'air dégoûté, mais vous le regardez fixement et il se retire, disant qu\'il va l\'enterrer correctement.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Repose en paix, chien.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				_event.m.Anatomist.m.XP = this.Const.LevelXP[_event.m.Anatomist.getLevel()];
				_event.m.Anatomist.updateLevel();
				this.List.push({
					id = 16,
					icon = "ui/icons/level.png",
					text = _event.m.Anatomist.getName() + " levels up"
				});
				local numWardogsToLose = 1;
				local stash = this.World.Assets.getStash().getItems();

				foreach( i, item in stash )
				{
					if (item != null && (item.getID() == "accessory.wardog" || item.getID() == "accessory.armored_wardog" || item.getID() == "accessory.warhound" || item.getID() == "accessory.armored_warhound"))
					{
						numWardogsToLose = --numWardogsToLose;
						stash[i] = null;
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "You lose " + item.getName()
						});
						break;
					}
				}

				if (numWardogsToLose != 0)
				{
					local brothers = this.World.getPlayerRoster().getAll();

					foreach( bro in brothers )
					{
						local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

						if (item != null && (item.getID() == "accessory.wardog" || item.getID() == "accessory.armored_wardog" || item.getID() == "accessory.warhound" || item.getID() == "accessory.armored_warhound"))
						{
							numWardogsToLose = --numWardogsToLose;
							bro.getItems().unequip(item);
							this.List.push({
								id = 10,
								icon = "ui/items/" + item.getIcon(),
								text = "You lose " + item.getName()
							});
							break;
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_19.png[/img]{Vous donnez le feu vert à %anatomist%. Il sourit comme un enfant qui reçoit son premier cadeau. Alors qu\'il s\'en va, vous vous demandez si vous n\'avez pas fait le mauvais choix. On entend l\'anatomiste se débattre avec le chien, le cliquetis de son collier et le grognement d\'un chien qui se fait malmener. Vous attendez le jappement, mais vous entendez à la place un cri humain, et même un peu féminin. Alors que vous vous précipitez pour voir ce qu\'il se passe, un gros chien passe en trombe. Vous trouvez %anatomist% sur le sol, se tenant la main. Sans se décourager ou peut-être en essayant de trouver une valeur pédagogique, l\'anatomiste se murmure de douces paroles scientifiques.%SPEECH_ON%Ah, je pense que ça prouve qu\'il y avait peut-être un peu de loup-garou dans son sang.%SPEECH_OFF%Malgré ce que %anatomist% pourrait récupérer comme informations à partir d\'une trainée de sang, le chien est introuvable. Sans doute a-t-il lui même compris qu\'une telle trahison ne sortait pas du néant. S\'il y a un loup dans ce chien, il y a aussi un chien ordinaire dans ce chien, et même un chien ordinaire sait quand ses maîtres l\'ont trahi.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Faites nettoyer cette blessure.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				local injury = _event.m.Anatomist.addInjury([
					{
						ID = "injury.missing_finger",
						Threshold = 0.0,
						Script = "injury_permanent/missing_finger_injury"
					}
				]);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Anatomist.getName() + " suffers " + injury.getNameOnly()
				});
				local numWardogsToLose = 1;
				local stash = this.World.Assets.getStash().getItems();

				foreach( i, item in stash )
				{
					if (item != null && (item.getID() == "accessory.wardog" || item.getID() == "accessory.armored_wardog" || item.getID() == "accessory.warhound" || item.getID() == "accessory.armored_warhound"))
					{
						numWardogsToLose = --numWardogsToLose;
						stash[i] = null;
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "You lose " + item.getName()
						});
						break;
					}
				}

				if (numWardogsToLose != 0)
				{
					local brothers = this.World.getPlayerRoster().getAll();

					foreach( bro in brothers )
					{
						local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

						if (item != null && (item.getID() == "accessory.wardog" || item.getID() == "accessory.armored_wardog" || item.getID() == "accessory.warhound" || item.getID() == "accessory.armored_warhound"))
						{
							numWardogsToLose = --numWardogsToLose;
							bro.getItems().unequip(item);
							this.List.push({
								id = 10,
								icon = "ui/items/" + item.getIcon(),
								text = "You lose " + item.getName()
							});
							break;
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_27.png[/img]{%anatomist% soupire, mais ne proteste pas beaucoup et finit par se soumettre à votre refus et s\'en va un peu penaud. S\'il avait une queue, se trouverait-elle à sa place entre ses jambes à ce moment précis? Telle est la question que vous vous posez. C\'est alors qu\'apparaît la perspective de ses projets scientifiques, le chien lui-même, qui remue la queue et porte un bâton dans sa gueule. Il dépose le bâton à vos pieds, mais lorsque vous allez le ramasser, le chien grogne et vous l\'arrache. Peut-être que ces étranges créatures auraient dû être étudiées...}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "D\'accord, petit bâtard...",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				_event.m.Anatomist.worsenMood(0.5, "Was denied the opportunity to study a wardog.");
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_06.png[/img]{Vous laissez %anatomist% faire ce qu\'il veut. Si votre travail consiste à les aider dans leurs tâches scientifiques, alors des incidents comme celui-ci en font partie. Un peu plus loin, on peut entendre l\'anatomiste se battre avec le chien et essayer de le coincer pour qu\'il meure rapidement. Mais ensuite, vous entendez la voix d\'un homme qui aboie sur le côté, et la lutte prend un ton nettement humain, avec plus de cris et de malédictions, et des voix qui implorent le pardon. Vous réalisez que vous aviez complètement oublié le maître-chien de la compagnie. Vous vous précipitez pour trouver %houndmaster% en train de fouetter l\'anatomiste avec une laisse de chien et de lui donner un coup de poing de temps en temps.%SPEECH_ON%Ça fait mal, hein? Et ça, alors? Dis-moi, est-ce que tu apprends en saignant? Tu crois que tes dents auront quel goût si je les transforme en poudre, hein?%SPEECH_OFF%En soupirant, vous vous approchez et arrachez le maître-chien de l\'anatomiste. %houndmaster% se défend en disant que %anatomist% essayait de tuer l\'un des chiens. Vous ignorez ce qu\'il raconte, disant qu\'il y a peut-être eu un malentendu quelque part. Vous regardez l\'anatomiste ensanglanté et lui dites de rester loin des chiens et avant qu\'il ne puisse se gargariser de protestations en disant que c\'est vous qui lui avez dit qu\'il pouvait le faire, vous faites demi-tour et partez.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Oops.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Anatomist.getImagePath());
				this.Characters.push(_event.m.Houndmaster.getImagePath());
				_event.m.Anatomist.addHeavyInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.Anatomist.getName() + " suffers heavy wounds"
				});
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.anatomists")
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local anatomistCandidates = [];
		local houndmasterCandidates = [];
		local numWardogs = 0;

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.anatomist" && bro.getLevel() <= 6)
			{
				anatomistCandidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.houndmaster")
			{
				houndmasterCandidates.push(bro);
			}

			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

			if (item != null && (item.getID() == "accessory.wardog" || item.getID() == "accessory.armored_wardog" || item.getID() == "accessory.warhound" || item.getID() == "accessory.armored_warhound"))
			{
				numWardogs = ++numWardogs;
			}
		}

		if (houndmasterCandidates.len() > 0)
		{
			this.m.Houndmaster = houndmasterCandidates[this.Math.rand(0, houndmasterCandidates.len() - 1)];
		}

		if (anatomistCandidates.len() == 0)
		{
			return;
		}

		if (numWardogs < 1)
		{
			local stash = this.World.Assets.getStash().getItems();

			foreach( item in stash )
			{
				if (item != null && (item.getID() == "accessory.wardog" || item.getID() == "accessory.armored_wardog" || item.getID() == "accessory.warhound" || item.getID() == "accessory.armored_warhound"))
				{
					numWardogs = ++numWardogs;

					if (numWardogs >= 1)
					{
						break;
					}
				}
			}
		}

		if (numWardogs < 1)
		{
			return;
		}

		this.m.Anatomist = anatomistCandidates[this.Math.rand(0, anatomistCandidates.len() - 1)];
		this.m.Score = 8;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"anatomist",
			this.m.Anatomist.getNameOnly()
		]);
		_vars.push([
			"houndmaster",
			this.m.Houndmaster != null ? this.m.Houndmaster.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Anatomist = null;
		this.m.Houndmaster = null;
	}

});

