this.dog_in_swamp_event <- this.inherit("scripts/events/event", {
	m = {
		Helper = null,
		Houndmaster = null,
		Beastslayer = null
	},
	function create()
	{
		this.m.ID = "event.dog_in_swamp";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 90.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_09.png[/img]Un cri strident perce le marasme du marais. Vous vous précipitez et trouvez un homme qui se débat dans les eaux, ses bras balançant des lianes de kudzu. L\'eau mousse et bouillonne, le museau d\'un chien apparaît brièvement et en profite pour aboyer à l\'aide au lieu de respirer pour prolonger momentanément sa vie. En vous voyant, le propriétaire du chien hurle.%SPEECH_ON%S\'il vous plaît, à l\'aide! Mon chien a été happé par quelque chose!%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "C\'est pas notre problème.",
					function getResult( _event )
					{
						return 0;
					}

				},
				{
					Text = "Les gars, il faut aider ce chien !",
					function getResult( _event )
					{
						if (this.Math.rand(1, 100) <= 60)
						{
							return "GoodEnding";
						}
						else
						{
							return "BadEnding";
						}
					}

				}
			],
			function start( _event )
			{
				local stash = this.World.Assets.getStash().getItems();
				local net = false;

				foreach( item in stash )
				{
					if (item != null && item.getID() == "tool.throwing_net")
					{
						net = true;
						break;
					}
				}

				if (net)
				{
					this.Options.push({
						Text = "Peut-être que je peux utiliser un de nos filets pour sauver ce chien.",
						function getResult( _event )
						{
							return "Net";
						}

					});
				}

				if (_event.m.Houndmaster != null)
				{
					this.Options.push({
						Text = "Peut-être que notre maître-chien peut aider ?",
						function getResult( _event )
						{
							return "Houndmaster";
						}

					});
				}

				if (_event.m.Beastslayer != null)
				{
					this.Options.push({
						Text = "%beastslayer%, vous avez l\'habitude de traiter avec des bêtes. Vous savez ce que c\'est?",
						function getResult( _event )
						{
							return "BeastSlayer";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "GoodEnding",
			Text = "[img]gfx/ui/events/event_09.png[/img]%helpbro% s\'avance dans l\'eau du marais en tendant les bras et en se balançant comme s\'il vissait le couvercle d\'un baril. Il lève l\'arme en hauteur et le propriétaire du chien observe nerveusement. Un sourire traverse le visage du mercenaire.%SPEECH_ON%Je t\'ai eu!%SPEECH_OFF%Il embroche l\'eau du marais et arrache un serpent plus long que tout ce que vous avez jamais vu, la bête se balance dans tous les sens tandis que le mercenaire parade avec son cadavre comme récompense. Le maître va chercher son chien, mais celui-ci lui glisse entre les mains comme si ses bras n\'étaient qu\'un autre serpent et il saute à côté de vous. Vous demandez si c\'est son chien. Il acquiesce, puis secoue lentement la tête.%SPEECH_ON%Je suppose que c\'est ton chien maintenant. C\'est un battant, celui-là, mais il n\'est rien du tout si ce n\'est un foutu nageur de merde. Je verrais ça comme un échange équitable si je pouvais garder ce serpent.%SPEECH_OFF%Vous acquiescez et faites l\'échange, en disant à %helpbro% de vous remettre son nouveau trophée.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je pense que je vais t\'appeler... Nageur.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Helper.getImagePath());
				local item = this.new("scripts/items/accessory/wardog_item");
				item.m.Name = "Swimmer";
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "BadEnding",
			Text = "[img]gfx/ui/events/event_09.png[/img]%helpbro% se dirige vers le rivage et dégaine son arme. Il s\'enfonce dans le bourbier comme un saint rempli de bière qui quitte la foule avant qu\'on ne reconnaisse son visage. Sa lutte est telle qu\'il tombe sur le chien et disparaît dans l\'écume et les remous de la bataille. Vous vous précipitez à ses côtés et le tirez sur le rivage, l\'homme couvert de mousse a ses bottes enveloppées de nénuphars et il hache l\'eau sale du marécage et en retire la saumure fermentée. On ne voit pas le chien, juste une légère ondulation de l\'eau qui s\'éloigne de la zone. Inquiet, son propriétaire acquiesce.%SPEECH_ON%J\'apprécie l\'effort, mais les choses sont ce qu\'elles sont. Le marais s\'occupe de ce genre de situations parce que c\'est un marais et que j\'emmerde ce putain d\'endroit. Si je pouvais, je verrais cette tache de merde de bizarrerie géographique vidée, brûlée et salée pour n\'être plus qu\'un terrain vague.!%SPEECH_OFF%Vous levez un sourcil et lui demandez s\'il vit dans le marais. Il prend une longue inspiration et acquiesce.%SPEECH_ON%Oui monsieur... et à perpetuité.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Eh bien, c\'était un effort qui valait la peine.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Helper.getImagePath());
				_event.m.Helper.addLightInjury();
				this.List.push({
					id = 10,
					icon = "ui/icons/days_wounded.png",
					text = _event.m.Helper.getName() + " souffre de blessures légères"
				});
			}

		});
		this.m.Screens.push({
			ID = "Houndmaster",
			Text = "[img]gfx/ui/events/event_09.png[/img]%houndmaster% le maître-chien se précipite pour aider, mais le chien à la surface du marais reste immobile. L\'homme se glisse dans l\'eau et observe ce qu\'il voit. Ses mains se crispent et il fixe l\'étranger.%SPEECH_ON%Je suis un maître-chien dans l\'âme. Ça veut dire que je les entraîne pour qu\'ils ne s\'attirent pas autant de problèmes. Mais je n\'ai jamais eu besoin d\'entraîner un chien à se méfier de cette tourbière, ce qui signifie que ce fils de pute l\'a jeté là-dedans, n\'est-ce pas?%SPEECH_OFF%Les premiers mots de l\'étranger sont des excuses mais le maître-chien le frappe. L\'étranger recule si maladroitement que son pantalon tombe sur ses chevilles et que de nombreux trésors tombent de ses poches. Ce fou furieux est un chasseur de trésors! %houndmaster% sort une arme et semble prêt à tuer cet homme. En hurlant, l\'étranger enlève son pantalon et s\'enfuit dans les bois du marais en hululant et en restant à moitié nu comme un sac à patates dominé par un fantôme. En riant, vous vous accroupissez pour passer en revue les biens du défunt, qui ne sont pas tous brillants.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Quelle honte. Et quel profit !",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Houndmaster.getImagePath());
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
			ID = "BeastSlayer",
			Text = "[img]gfx/ui/events/event_09.png[/img]Le tueur de créatures, %beastslayer%, hoche la tête et s\'enfonce dans le marais. Il s\'approche calmement de l\'eau agitée et se tient au-dessus, fixant la boue de ses yeux de gauche à droite comme s\'il observait des carpes dans des eaux claires. Enfin, il sort un couteau de table et l\'enfonce dans l\'eau. Une fois de plus. Et encore. Le chien fait surface pour respirer. Le tueur l\'enfonce à nouveau et cette fois le chien s\'échappe et va entre vos jambes où il se blottit, mouillé et gémissant. Le %beastslayer% tient quelque chose dans sa main puis le lâche, quoi que ce soit, l\'objet plonge à travers le marais, l\'eau ondulant dans son sillage.%SPEECH_ON%Rien qu\'un serpent, capitaine.%SPEECH_OFF%Le tueur de bêtes sort son pied de l\'eau et sur son orteil se trouve un gobelet brillant. Il considère l\'étranger du marais avec un mépris total.%SPEECH_ON%Votre lâcheté a fait de vous un monstre, un chasseur de trésor, un vrai sauvage qui utiliserait un chien à la place de ses propres mains. Tu n\'as rien à faire dans ces marais. Quand je me retournerai, vous feriez mieux d\'être parti, compris ?%SPEECH_OFF%Le tueur de bêtes vous donne le gobelet et l\'étranger se retire sans délai.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Très bien.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Beastslayer.getImagePath());
				local item = this.new("scripts/items/accessory/wardog_item");
				item.m.Name = "Nageur";
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
				item = this.new("scripts/items/loot/golden_chalice_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "Net",
			Text = "[img]gfx/ui/events/event_09.png[/img]Vous récupérez un filet dans l\'inventaire et le lancez sur le chien. Malgré les secousses, le bord du filet s\'enfonce doucement dans la boue comme un enfant capturerait lentement une mouche agile. Quelques mercenaires se joignent à vous et vont dans la tourbière pour tendre les cordes et tirer le filet sur le rivage. Les pattes du chien dépassent des attaches dans tous les sens et même si sa vie est en jeu, il regarde avec ses yeux de chiens battu. Ce qui retenait le chien semble avoir pris conscience du danger et se libère, vous regardez une sorte de corde verte glissante se déplier et replonger dans l\'eau, elle disparaît sans la moindre ondulation.\n\n %randombrother% souligne la bonne santé du chien et son comportement obéissant. En effet, il semble déjà ne pas avoir été affecté par son contact avec la mort, offrant un aboiement amical en guise de témoignage. Vous dites à l\'étranger que le chien appartient désormais à la compagnie.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je pense que je vais t\'appeler... Nageur.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/accessory/wardog_item");
				item.m.Name = "Swimmer";
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
				local stash = this.World.Assets.getStash().getItems();

				foreach( i, item in stash )
				{
					if (item != null && item.getID() == "tool.throwing_net")
					{
						this.List.push({
							id = 10,
							icon = "ui/items/" + item.getIcon(),
							text = "Vous perdez " + item.getName()
						});
						stash[i] = null;
						break;
					}
				}
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

		if (currentTile.Type != this.Const.World.TerrainType.Swamp)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_houndmaster = [];
		local candidates_beastslayer = [];
		local candidates_other = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.houndmaster")
			{
				candidates_houndmaster.push(bro);
			}
			else if (bro.getBackground().getID() == "background.beast_slayer")
			{
				candidates_beastslayer.push(bro);
			}
			else if (!bro.getSkills().hasSkill("trait.player"))
			{
				candidates_other.push(bro);
			}
		}

		if (candidates_other.len() == 0)
		{
			return;
		}

		this.m.Helper = candidates_other[this.Math.rand(0, candidates_other.len() - 1)];

		if (candidates_houndmaster.len() != 0)
		{
			this.m.Houndmaster = candidates_houndmaster[this.Math.rand(0, candidates_houndmaster.len() - 1)];
		}

		if (candidates_beastslayer.len() != 0)
		{
			this.m.Beastslayer = candidates_beastslayer[this.Math.rand(0, candidates_beastslayer.len() - 1)];
		}

		this.m.Score = 10;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"helpbro",
			this.m.Helper.getNameOnly()
		]);
		_vars.push([
			"houndmaster",
			this.m.Houndmaster ? this.m.Houndmaster.getNameOnly() : ""
		]);
		_vars.push([
			"beastslayer",
			this.m.Beastslayer ? this.m.Beastslayer.getNameOnly() : ""
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Helper = null;
		this.m.Houndmaster = null;
		this.m.Beastslayer = null;
	}

});

