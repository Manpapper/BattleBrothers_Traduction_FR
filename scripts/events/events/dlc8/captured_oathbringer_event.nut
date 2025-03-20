this.captured_oathbringer_event <- this.inherit("scripts/events/event", {
	m = {
		Torturer = null
	},
	function create()
	{
		this.m.ID = "event.captured_oathbringer";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "{[img]gfx/ui/events/event_05.png[/img]{Un des hommes se précipite dans votre tente en s\'exclamant que quelqu\'un a été surpris en train de se faufiler dans le camp. Vous demandez si c\'est un voleur. L\'homme secoue la tête.%SPEECH_ON%Non, pire. C\'est un Oathbringer.%SPEECH_OFF%Fils de pute. Vous vous levez d\'un bond et vous vous précipitez, trouvant cet intrus déjà ligoté et battu par les Oathtakers. Vous les interrompez et venez vous placer devant lui.%SPEECH_ON%Oathbringer, où est la mâchoire d\'Anselm?%SPEECH_OFF%L\'homme crache sur votre botte et vous dit qu\'il n\'y renoncera jamais, et que les Oathtakers peuvent aller en enfer et qu\'Anselm lui-même les y accompagnerait s\'il le pouvait. Ce blasphème du jeune Anselm suscite des halètements chez vous et vos hommes. %randombrother% se penche.%SPEECH_ON%Donnez l\'ordre, capitaine, et nous montrerons à ce Oathbringer l\'erreur qu\'il commet.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Tuez-le.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Torturez-le.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 80 ? "C" : "D";
					}

				},
				{
					Text = "Laissez-le partir.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "{[img]gfx/ui/events/event_05.png[/img]{Vous dégainez votre épée et la plongez dans son cœur.%SPEECH_ON%Anselm ne t\'attendra pas de l\'autre côté, hérétique.%SPEECH_OFF%Le corps de l\'homme fléchit devant l\'acier, ses yeux s\'écarquillent brièvement avant de se fixer sur le sol. Vous retirez votre épée et la compagnie %companyname% applaudit.%SPEECH_ON%Mort à tous les Oathbringers!%SPEECH_OFF%Les Oathtakers dégainent leurs épées et les lèvent vers le ciel tandis qu\'une atmosphère de fureur envahit la compagnie.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Justice a été rendue.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local potential_loot = [
					"armor/adorned_mail_shirt",
					"helmets/heavy_mail_coif",
					"helmets/heavy_mail_coif"
				];
				local item = this.new("scripts/items/" + potential_loot[this.Math.rand(0, potential_loot.len() - 1)]);
				item.setCondition(this.Math.max(1, item.getConditionMax() * this.Math.rand(10, 30) * 0.01));
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
				this.World.Assets.getStash().add(item);
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.paladin" || !bro.getBackground().isOffendedByViolence() && this.Math.rand(1, 100) <= 75)
					{
						bro.improveMood(0.75, "Pleased you slew an Oathbringer heretic");

						if (bro.getMoodState() > this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (bro.getBackground().isOffendedByViolence())
					{
						bro.worsenMood(0.5, "Disliked that you slew a captive in cold blood");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
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
			Text = "{[img]gfx/ui/events/event_05.png[/img]{Vous acquiescez.%SPEECH_ON%Torturez-le jusqu\'à ce qu\'il crache l\'endroit où se trouve la mâchoire du Jeune Anselm. Je me fiche de savoir comment vous le faites, faites-le, c\'est tout.%SPEECH_OFF%Vous partez pendant que le prisonnier dit qu\'Anselm n\'approuverait pas. Il se met alors à hurler sans discernement et finit par crier des choses qui n\'ont pas beaucoup de sens. Vous vous retirez dans votre tente, en faisant rebondir votre pied sur les cris qui prennent maintenant une sorte de gémissement rythmique. Finalement, %randombrother% réapparaît. Il a avec lui quelques armes et armures qui sortent d\'on ne sait où.%SPEECH_ON%Il nous a conduit à un endroit où ils étaient cachés, mais la mâchoire d\'Anselm manque toujours. J\'ai bien peur que les Oathbringers ne l\'aient dans leur propre camp, mais il n\'a pas voulu dire où il se trouvait. Nous avons eu quelques difficultés à communiquer après lui avoir coupé la langue.%SPEECH_OFF%En soupirant, vous demandez où est le prisonnier maintenant. L\'homme s\'éclaircit la gorge.%SPEECH_ON%Oh, il est devenu tout blanc et s\'est écroulé. Il est mort, monsieur.%SPEECH_OFF%Au moins, nous avons fait quelque chose de bien pour le Jeune Anselm.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Nous allons trouver la mâchoire.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local potential_loot = [
					"armor/adorned_warriors_armor",
					"helmets/adorned_closed_flat_top_with_mail",
					"helmets/adorned_closed_flat_top_with_mail"
				];
				local item = this.new("scripts/items/" + potential_loot[this.Math.rand(0, potential_loot.len() - 1)]);
				item.setCondition(this.Math.max(1, item.getConditionMax() * this.Math.rand(10, 30) * 0.01));
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
				this.World.Assets.getStash().add(item);
				potential_loot = [
					"weapons/arming_sword",
					"weapons/fighting_axe",
					"weapons/military_cleaver",
					"shields/heater_shield"
				];
				item = this.new("scripts/items/" + potential_loot[this.Math.rand(0, potential_loot.len() - 1)]);
				item.setCondition(this.Math.max(1, item.getConditionMax() * this.Math.rand(10, 30) * 0.01));
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + item.getName()
				});
				this.World.Assets.getStash().add(item);
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getBackground().getID() == "background.paladin" || !bro.getBackground().isOffendedByViolence() && this.Math.rand(1, 100) <= 75)
					{
						bro.improveMood(1.25, "Tortured an Oathbringer heretic");

						if (bro.getMoodState() > this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
					else if (bro.getBackground().isOffendedByViolence())
					{
						bro.worsenMood(0.75, "Is horrified that you ordered a captive tortured");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
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
			Text = "{[img]gfx/ui/events/event_05.png[/img]{Vous dites aux hommes de torturer l\'homme pour obtenir des informations. S\'il y a une chose que tous les Oathbringer savent, c\'est où se trouve la mâchoire du Jeune Anselm et c\'est quelque chose que chaque Oathtaker souhaite découvrir. L\'homme hurle tandis qu\'on le traîne. Vous vous retirez dans votre tente afin que ces cris n\'entachent pas votre humeur. Un moment plus tard, %torturer% entre dans la tente avec sang sur sa chemise. Il semble vouloir parler, puis s\'effondre sur le sol. Un autre Oathtaker entre en disant que le prisonnier s\'est échappé et a frappé son tortionnaire avant de s\'enfuir. Dites aux hommes d\'aider %torturer% avant qu\'il ne se vide de son sang.%SPEECH_ON%Ces maudits Oathbringers n\'ont aucun honneur! Nous le trouverons et le tuerons, comme le dirait le Jeune Anselm, comme nous le disons tous!%SPEECH_OFF%Vous parlez avec une mâchoire serrée et un air théâtral. La vérité, c\'est que le bâtard s\'est échappé et que ces Oathbringers sont difficiles à attraper. Vous espérez juste que %torturer% survivra.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Saleté d\'Oathbringer.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				_event.m.Torturer.addHeavyInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.Torturer.getName() + " suffers heavy wounds"
				});
				local injury = _event.m.Torturer.addInjury([
					{
						ID = "injury.cut_throat",
						Threshold = 0.0,
						Script = "injury/cut_throat_injury"
					}
				]);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Torturer.getName() + " suffers " + injury.getNameOnly()
				});
				_event.m.Torturer.worsenMood(0.5, "Let a captive Oathbringer escape");
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "{[img]gfx/ui/events/event_05.png[/img]{Cet homme n\'a rien de valeur. Vous dites aux hommes de le libérer. Ils protestent, disant qu\'un Oathbringer n\'a qu\'un seul et unique choix à faire, c\'est de se soumettre aux Oathtakers et à la Voie Finale, ou mourir. Il y a aussi de la place pour celui qui rend la mâchoire du Jeune Anselm, mais les codes sur la façon de traiter un Oathbringer qui le fait n\'ont pas encore été définis. Mais, en ce qui concerne cet homme, il n\'est pas vraiment utile et vous n\'êtes pas d\'humeur à verser du sang. Alors que vous vous apprêtez à le libérer, %randombrother% lui tranche la gorge, sous les acclamations des autres.%SPEECH_ON%Vous avez dit de le couper, n\'est-ce pas capitaine? C\'est ça?%SPEECH_OFF%Vous réalisez que l\'Oathtaker vous couvre, et continuer à nier que l\'Oathbringer devait mourir pourrait vous mettre dans une situation délicate. Vous acquiescez.%SPEECH_ON%Oui, bien sûr, le petit rat devait mourir, comme tous les Oathbringers! Et ils mourront tous!%SPEECH_OFF%Les hommes hurlent à nouveau, mais vous avez le sentiment que quelques-uns se souviendront de votre suggestion ridicule de laisser un Oathbringer en liberté.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je devrais faire plus attention à ce que je dis.",
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
					if (bro.getBackground().getID() == "background.paladin" || this.Math.rand(1, 100) <= 75)
					{
						bro.worsenMood(0.75, "You almost let a captive Oathbringer roam free");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
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
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Paladins)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.paladins")
		{
			return;
		}

		if (this.World.getTime().Days < 35)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local torturer_candidates = [];
		local haveSkull = false;

		foreach( bro in brothers )
		{
			local item = bro.getItems().getItemAtSlot(this.Const.ItemSlot.Accessory);

			if (item != null && item.getID() == "accessory.oathtaker_skull_02")
			{
				haveSkull = true;
			}

			if (bro.getBackground().getID() == "background.paladin")
			{
				torturer_candidates.push(bro);
			}
		}

		if (!haveSkull)
		{
			local stash = this.World.Assets.getStash().getItems();

			foreach( item in stash )
			{
				if (item != null && item.getID() == "accessory.oathtaker_skull_02")
				{
					haveSkull = true;
					break;
				}
			}
		}

		if (haveSkull)
		{
			return;
		}

		if (torturer_candidates.len() == 0)
		{
			torturer_candidates.push(brothers[this.Math.rand(0, brothers.len() - 1)]);
		}

		this.m.Torturer = torturer_candidates[this.Math.rand(0, torturer_candidates.len() - 1)];
		this.m.Score = 7;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"torturer",
			this.m.Torturer.getName()
		]);
	}

	function onClear()
	{
		this.m.Torturer = null;
	}

});

