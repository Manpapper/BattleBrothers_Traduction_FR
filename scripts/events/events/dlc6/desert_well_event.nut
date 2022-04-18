this.desert_well_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null,
		Monk = null
	},
	function create()
	{
		this.m.ID = "event.desert_well";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "%terrainImage%{Vous arrivez à un abreuvoir. Les murs extérieurs du puits sont brodés de crânes d\'animaux et leurs côtes sont cousues de façon similaire. Alors que vous vous approchez, il y a un léger sifflement provenant des profondeurs. En regardant à l\'intérieur, vous voyez une petite lueur orange qui serpente de gauche à droite.%SPEECH_ON%Vous devriez essayer de ne pas regarder en bas.%SPEECH_OFF%Vous vous retournez pour voir un homme habillé en haillons. Ses cheveux sont hérissés en arrière par des chevrons noirs. Des taches sombres parsèment son visage et il a des bleus sur chaque ongle et un sourire goudronné..%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Qu\'est-ce qui est sur le point d\'exploser ?",
					function getResult( _event )
					{
						return "B";
					}

				}
			],
			function start( _event )
			{
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "%terrainImage%{L\'homme hoche la tête. C\'est pas un trou d\'eau, c\'est un canon. J\'ai un tas de poudre à feu au fond. La chute est armée de seaux, de cannes à pêche, de toutes sortes de couverts, de bottes en métal de soldat, d\'une épée cassée, de deux fourreaux, je pense que quelques animaux sont tombés dedans mais ils sont sans doute morts maintenant, sinon ils vont faire un tour.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Oh non, ne faites pas ça !",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				if (_event.m.Monk != null)
				{
					this.Options.push({
						Text = "Les dieux te parlent, %monk%, maintenant tu lui parles !",
						function getResult( _event )
						{
							return "D";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "%terrainImage%{L\'homme sourit. Tu ne sais rien de moi, étranger. Peut-être que je vise à me suicider parce que j\'ai commis un crime terrible.  Je veux dire, je ne l\'ai pas fait, mais qu\'est-ce qui vous prend de dire de ne pas le faire ? Vous avez vu ma préparation, si j\'avais eu l\'intention de faire une pause, ne l\'aurais-je pas fait à un moment donné ? Maintenant tu restes là et tu regardes ça. Il se retourne et saute dans le trou. Il y a un bruit de chute, un murmure sur le fait qu\'il y a plus de débris que ce dont il se souvient. Quand vous regardez en bas, il vous crie de dégager et la lueur orange s\'engouffre dans un trou. L\'homme s\'incline. %SPEECH_ON%Je te souhaite un bon voyage, étranger, un étrange voyage.%SPEECH_OFF% L\'explosion vous souffle les oreilles et vous met à terre. La terre roule sous vous dans un tremblement que vous pouvez ressentir à travers la surdité dans laquelle vous êtes maintenant plongé. Un nuage de feu s\'élève dans le ciel et gronde avec le tintement et le cliquetis des métaux et le bruit sourd du cuir et d\'autres marchandises, et vous roulez sur le ventre et vous couvrez votre tête alors que tout tombe comme les débris d\'une tempête infernale. Quant à l\'homme lui-même, eh bien, il a eu ce qu\'il voulait. Il est sans doute mort en un clin d\'œil, il ne reste que des morceaux carbonisés ici et là, des poumons grillés, des morceaux de tendons brûlés et bien d\'autres choses encore. Vous vérifiez que vos sourcils sont toujours là et, satisfait, vous vous préparez à avancer.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Parfois, on souhaite que ces choses ne soient que des mirages.",
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
			Text = "%terrainImage%{%monk% le moine s\'avance.%SPEECH_ON%C\'est beaucoup de travail pour en finir avec soi-même, mon ami.%SPEECH_OFF%L\'homme hausse les épaules.%SPEECH_ON%Je ne suis pas vraiment votre ami.%SPEECH_OFF%Le moine acquiesce.%SPEECH_ON%Tournure de phrase, rien de plus. En vérité, je ne sais rien de vous. En vérité, vous avez probablement une bonne raison de faire cela. Combien de temps avez-vous passé à mettre tout cela sur pied ? %SPEECH_OFF%L\'homme étrange réfléchit un moment, puis dit qu\'il pense que cela fait des mois. Le moine sourit. %SPEECH_ON% C\'est du bon travail. %SPEECH_OFF% L\'homme dit.%SPEECH_ON% Tu essaies de me dorloter ? %SPEECH_OFF% Le moine secoue la tête. %SPEECH_ON% Non Monsieur.%SPEECH_OFF% L\'homme ferme les yeux et regarde incrédule. %SPEECH_ON% Ça ressemble à des paroles maternelles. Comme si tu essayais de me convaincre de ne pas me tuer. Et bien je ne veux pas!%SPEECH_OFF%%monk% hausse les épaules.%SPEECH_ON%Encore, non monsieur. Allez-y et mettez fin à vos jours si c\'est ce que vous souhaitez. Aujourd\'hui ou plus tard, les vieux dieux t\'attendront.%SPEECH_OFF%L\'homme se retourne et crache.%SPEECH_ON%Pas de vieux dieux ici. Il n\'y a que la lueur et l\'éclat du doreur. Le moine hoche la tête et se tourne vers vous. Pour être franc, capitaine, je n\'ai plus qu\'une chose à dire. Je peux le dire ? Je veux juste le dire à l\'étranger, le lui dire directement..%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Allez-y.",
					function getResult( _event )
					{
						return "E";
					}

				},
				{
					Text = "Laissez-le se tuer si c\'est ce qu\'il veut.",
					function getResult( _event )
					{
						return "F";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "%terrainImage%{Le moine hoche la tête en signe d\'approbation, puis se retourne soudainement et assomme l\'étranger. Il tombe de la paroi du puits et s\'effondre dans la terre, regardant vers le haut avec ses yeux déformés. L\'homme s\'accroupit. %SPEECH_ON% C\'est comment ? %SPEECH_OFF% L\'étranger ricane et crache du sang. Il dit que ça fait mal. Le moine hoche la tête. %SPEECH_ON%Se sentir vivant?%SPEECH_OFF%L\'étranger se lève et s\'époussette. Il hoche la tête. %SPEECH_ON%Un peu, ouais.%SPEECH_OFF%Les deux parlent un moment et quand c\'est fini l\'homme est prêt à rejoindre la compagnie gratuitement. Il dit aussi qu\'il y a un certain nombre de biens dans le puits s\'ils veulent les utilisés, mais qu\'il faut faire attention à ne pas y jeter du feu parce que ça va exploser en plein ciel.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bienvenue à bord, je suppose.",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk.getImagePath());
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"peddler_southern_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "Une série de malchances a conduit l\'ancien trafiquant d\'armes %name% à tenter de mettre fin à sa vie en se faisant exploser, mais " + _event.m.Monk.getName() + " est intervenu et l\'a convaincu de rejoindre votre compagnie pour refaire sa vie.";
				_event.m.Dude.getBackground().buildDescription(true);
				local trait = this.new("scripts/skills/traits/deathwish_trait");

				foreach( id in trait.m.Excluded )
				{
					_event.m.Dude.getSkills().removeByID(id);
				}

				_event.m.Dude.getSkills().add(trait);
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand));
				_event.m.Dude.getItems().unequip(_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand));
				_event.m.Dude.worsenMood(2.5, "Il a eu une série de malchance et a tout perdu");
				this.Characters.push(_event.m.Dude.getImagePath());
				local item = this.new("scripts/items/loot/silverware_item");
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
			Text = "%terrainImage%{Vous dites au moine de se retirer. Il hausse les épaules et retourne à vos côtés. Lorsque vous regardez à nouveau l\'homme, vous réalisez qu\'il a allumé un feu et vous le regardez sauter dans le puits. L\'explosion vous souffle les oreilles et vous met à terre. La terre roule sous vous dans un tremblement que vous pouvez ressentir à travers la surdité dans laquelle vous êtes maintenant plongé. Un nuage de feu s\'élève dans le ciel et gronde avec le tintement et le cliquetis des métaux et le bruit sourd du cuir et d\'autres marchandises, et vous vous retournez sur le ventre et vous couvrez votre tête alors que tout tombe comme les débris d\'une tempête infernale. Quant à l\'homme lui-même, eh bien, son souhait a été exaucé. Il est sans doute mort en un clin d\'œil, il ne reste que des morceaux carbonisés ici et là, des poumons grillés, des morceaux de tendons brûlés et bien d\'autres choses encore. Vous vérifiez que vos sourcils sont toujours là et, satisfait, vous vous préparez à avancer.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Parfois, on souhaite que ces choses ne soient que des mirages.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Monk.getImagePath());
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

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local towns = this.World.EntityManager.getSettlements();

		foreach( t in towns )
		{
			if (t.getTile().getDistanceTo(currentTile) <= 6)
			{
				return;
			}
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_monk = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.monk")
			{
				candidates_monk.push(bro);
			}
		}

		if (candidates_monk.len() != 0)
		{
			this.m.Monk = candidates_monk[this.Math.rand(0, candidates_monk.len() - 1)];
		}

		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"monk",
			this.m.Monk != null ? this.m.Monk.getNameOnly() : ""
		]);
	}

	function onClear()
	{
		this.m.Dude = null;
		this.m.Monk = null;
	}

});

